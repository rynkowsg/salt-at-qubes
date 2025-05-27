{#
#}

{%- set ns = slsdotpath + '.' + tplfile.split('/')[-1].split('.')[0] -%}

{%- import slspath ~ "/vars.jinja" as vars -%}

"{{ ns }}/38-installed":
  qvm.template_installed:
    - name: fedora-38-minimal
    - from: {{ vars.repo }}

"{{ ns }}/39-installed":
  qvm.template_installed:
    - name: fedora-39-minimal
    - from: {{ vars.repo }}

"{{ ns }}/40-installed":
  qvm.template_installed:
    - name: fedora-40-minimal
    - from: {{ vars.repo }}

"{{ ns }}/41-installed":
  qvm.template_installed:
    - name: fedora-41-minimal
    - from: {{ vars.repo }}
