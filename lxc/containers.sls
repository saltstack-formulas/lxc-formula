{% from "lxc/map.jinja" import lxc with context %}

include:
  - lxc

{% set lxc_pillar = salt['pillar.get']('lxc', {}) %}

{% for name, config in lxc_pillar.get('containers', {}).items() %}
{%   set container_profile = lxc_pillar.get('container_profile').get(config.get('profile')) %}
lxc--containers--lxc-create--{{ name }}:
  cmd.run:
    - name: lxc-create -n {{ name }} --config /var/lib/lxc/{{ name }}/config --template {{ container_profile.get('template') }} 
    - unless: lxc-info -n {{ name }}

lxc--containers--lxc-present--{{ name }}:
  lxc.present:
    - name: {{ name }}
    - template: {{ container_profile.get('template') }}
    - profile: {{ config.get('container_profile') }}
    - network_profile: {{ config.get('network_profile') }}
    - options:
        release: {{ container_profile.get('options').get('release') }}
    - require:
      - cmd: lxc--containers--lxc-create--{{ name }}

lxc--constainers--{{ name }}_config:
  file.managed:
    - name: /var/lib/lxc/{{ name }}/config
    - source: salt://lxc/files/config_v{{ lxc.version }}.jinja
    - template: jinja
    - defaults:
        template: {{ container_profile.get('template') }}
        name: {{ name }}
        arch: amd64
        interfaces: {{ config.get("interfaces", {}) | json }}
        config: {{ config.get("config", {}) | json }}
        network_profile: {{ config.get("network_profile") }}
    - require:
      - cmd: lxc--containers--lxc-create--{{ name }}

"lxc--containers--stop_lxc_{{ name }}":
  cmd.run:
    - name: "lxc-stop -n {{ name }}"
    - onlyif: lxc-info -n siemens-repos | grep -q '^State:\s*RUNNING$'
    - onchanges:
      - file: lxc--constainers--{{ name }}_config
      - lxc: lxc--containers--lxc-present--{{ name }}

lxc--containers--lxc-running--{{ name }}:
  lxc.running:
    - name: {{ name }}
{% endfor %}
