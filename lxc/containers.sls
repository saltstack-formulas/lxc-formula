{% from "lxc/map.jinja" import lxc with context %}

include:
  - lxc

{% for name, config in salt['pillar.get']('lxc:containers', {}).items() %}
{{ name }}:
  lxc.present:
    - template: ubuntu
    - profile: {{ config['profile'] }}
    - network_profile: {{ config['network_profile'] }}
    - running: True

{{ name }}_config:
  file.managed:
    - name: /var/lib/lxc/{{ name }}/config
    - source: salt://lxc/files/config_v{{ lxc.version }}.jinja
    - template: jinja
    - defaults:
        template: {{ salt['pillar.get']("lxc:container_profile:{}:template".format(config.get("profile"))) }}
        name: {{ name }}
        arch: amd64
        interfaces: {{ config.get("interfaces", {}) | json }}
        config: {{ config.get("config", {}) | json }}
        network_profile: {{ config.get("network_profile") }}

"restart_lxc_{{ name }}":
  cmd.run:
    - name: "sh -c 'lxc-stop -n {{ name }}; lxc-start -n {{ name }}'"
    - onchanges:
      - file: {{ name }}_config
      - cmd: "strong_RSA_key_{{ name }}"
{% endfor %}
