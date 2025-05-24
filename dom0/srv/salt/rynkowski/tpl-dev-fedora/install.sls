{#
#}

{% if grains['id'] == 'dom0' %}

{% elif grains['id'] is match('^tpl-dev-fedora-(39|40|41)$') %}

{%- import slsdotpath ~ "/vars.jinja" as vars -%}

include:
  - catalog.misc.pkgs_updated

"{{ slsdotpath }}-pkgs-installed":
  pkg.installed:
    - require:
      - pkg: catalog.misc.pkgs_updated/default
    - install_recommends: False
    - skip_suggestions: True
    - pkgs: {{ vars.pkgs|sequence|yaml }}

{% endif %}
