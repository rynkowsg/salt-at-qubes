{#
#}

{%- set ns = slsdotpath + '.' + tplfile.split('/')[-1].split('.')[0] -%}

{%- import slspath ~ "/vars.jinja" as vars -%}

{%- set menu_items_list = [
  'xterm.desktop'
] -%}

{% for os_version in [38, 39, 40, 41] %}
"{{ ns }}/fedora-{{ os_version }}-minimal-installed":
  qvm.template_installed:
    - name: fedora-{{ os_version }}-minimal
    - from: {{ vars.repo_fedora }}

"{{ ns }}/fedora-{{ os_version }}-minimal-menuapps-set":
  qvm.vm:
    - require:
        - qvm: "{{ ns }}/fedora-{{ os_version }}-minimal-installed"
    - name: fedora-{{ os_version }}-minimal
    - features:
        - set:
            - menu-items: "{{ menu_items_list | join(' ') }}"
            - default-menu-items: "{{ menu_items_list | join(' ') }}"
{% endfor %}
