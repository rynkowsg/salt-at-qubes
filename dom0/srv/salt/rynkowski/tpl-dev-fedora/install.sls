{#
#}

{% if grains['id'] == 'dom0' %}

{% elif grains['id'] is match('^tpl-dev-fedora-(39|40|41)$') %}

{%- import slsdotpath ~ "/vars.jinja" as vars -%}

include:
  - _lib_sls.common.update

"{{ slsdotpath }}-pkgs-installed":
  pkg.installed:
    - require:
      - sls: _lib_sls.common.update
    - install_recommends: False
    - skip_suggestions: True
    - pkgs: {{ vars.pkgs|sequence|yaml }}

{% endif %}
