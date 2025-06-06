{#
#}

{%- set ns = slsdotpath + '.' + tplfile.split('/')[-1].split('.')[0] -%}

#
# FIRSTLY,
# In each template, install the necessary packages
#

{% if grains['id'] is match('^tpl-dev-fedora-(39|40|41)$') %}

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

#
# THEN,
# for all templates specified in pillar, add menu apps
#

{% if grains['id']|lower == 'dom0' %}

{%- set templates = salt['pillar.get']('templates', []) -%}
{%- set menu_items_list = [
  "xfce4-terminal.desktop"
] -%}

{% for tpl in templates %}
"{{ ns }}/{{ tpl }}-menuapps-set":
  qvm.vm:
    - name: {{ tpl }}
    - features:
        - set:
            - menu-items: "{{ menu_items_list | join(' ') }}"
            - default-menu-items: "{{ menu_items_list | join(' ') }}"
{% endfor %}

{% endif %}
