{#
#}

{%- set ns = slsdotpath + '.' + tplfile.split('/')[-1].split('.')[0] -%}

{%- import slspath ~ "/vars.jinja" as vars -%}

"{{ ns }}/11-installed":
  qvm.template_installed:
    - name: debian-11-minimal
    - from: {{ vars.repo }}

"{{ ns }}/12-installed":
  qvm.template_installed:
    - name: debian-12-minimal
    - from: {{ vars.repo }}
