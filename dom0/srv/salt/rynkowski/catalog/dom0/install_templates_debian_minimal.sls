{#
#}

{%- set ns = slsdotpath + '.' + tplfile.split('/')[-1].split('.')[0] -%}

{%- import slspath ~ "/vars.jinja" as vars -%}

{% for os_version in [11, 12] %}
"{{ ns }}/debian-{{ os_version }}-minimal-installed":
  qvm.template_installed:
    - name: debian-{{ os_version }}-minimal
    - from: {{ vars.repo_debian }}
{% endfor %}
