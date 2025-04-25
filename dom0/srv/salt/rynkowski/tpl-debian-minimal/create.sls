{#
#}

{%- import slsdotpath ~ "/vars.jinja" as vars -%}

"{{ slsdotpath }}.11-installed":
  qvm.template_installed:
    - name: debian-11-minimal
    - from: {{ vars.repo }}

"{{ slsdotpath }}.12-installed":
  qvm.template_installed:
    - name: debian-12-minimal
    - from: {{ vars.repo }}
