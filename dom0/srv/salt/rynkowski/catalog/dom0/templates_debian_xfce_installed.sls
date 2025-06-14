{#
#}

{%- set ns = slsdotpath + '.' + tplfile.split('/')[-1].split('.')[0] -%}

{%- import slspath ~ "/vars.jinja" as vars -%}

# -------------------
#  INSTALL TEMPLATES
# -------------------

{%- set template_list = [
  'debian-11',
  'debian-12-xfce',
] -%}

{% for tmpl_name in template_list %}
"{{ ns }}/template-{{ tmpl_name }}-installed":
  qvm.template_installed:
    - name: {{ tmpl_name }}
    - from: {{ vars.repo_debian }}
{% endfor %}

# ----------------
#  SET MENU ICONS
# ----------------

{%- set menu_items_list = [
  'xfce-settings-manager.desktop',
  'xfce4-terminal.desktop',
] -%}

{%- set default_menu_items_list = [
  'Thunar.desktop',
  'firefox-esr.desktop',
  'xfce-settings-manager.desktop',
  'xfce4-terminal.desktop',
] -%}

{% for tmpl_name in template_list %}
"{{ ns }}/template-{{ tmpl_name }}-menuapps-set":
  qvm.vm:
    - require:
        - qvm: "{{ ns }}/template-{{ tmpl_name }}-installed"
    - name: {{ tmpl_name }}
    - features:
        - set:
            - menu-items: "{{ menu_items_list | join(' ') }}"
            - default-menu-items: "{{ default_menu_items_list | join(' ') }}"
{% endfor %}

#
# To list all templates:
#
#     $ qvm-template list
#
