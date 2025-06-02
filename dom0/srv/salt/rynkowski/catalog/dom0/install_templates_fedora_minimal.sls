{#
#}

{%- set ns = slsdotpath + '.' + tplfile.split('/')[-1].split('.')[0] -%}

{%- import slspath ~ "/vars.jinja" as vars -%}

{% for os_version in [38, 39, 40, 41] %}
"{{ ns }}/fedora-{{ os_version }}-minimal-installed":
  qvm.template_installed:
    - name: fedora-{{ os_version }}-minimal
    - from: {{ vars.repo_fedora }}
{% endfor %}
