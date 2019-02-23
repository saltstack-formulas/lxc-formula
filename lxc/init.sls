{% from "lxc/map.jinja" import lxc with context %}

{%- for pkg in lxc.get('pkgs', []) %}
"lxc_pkg_{{ pkg }}":
  pkg.installed:
    - name: {{ pkg }}
{%- endfor %}
