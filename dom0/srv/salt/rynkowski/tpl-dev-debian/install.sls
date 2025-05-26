{#
#}

{% set ns = slsdotpath + '.' + tplfile.split('/')[-1].split('.')[0] %}

{% if grains['id'] == 'dom0' %}

{% elif grains['id'] is match('^tpl-dev-debian-(11|12)$') %}

{%- import slspath ~ "/vars.jinja" as vars -%}

include:
  - catalog.misc.pkgs_updated

"{{ ns }}/pkgs-installed":
  pkg.installed:
    - require:
      - pkg: catalog.misc.pkgs_updated/default
    - install_recommends: False
    - skip_suggestions: True
    - pkgs: {{ vars.pkgs|sequence|yaml }}

{% endif %}
