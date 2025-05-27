{#
#}

{%- set ns = slsdotpath + '.' + tplfile.split('/')[-1].split('.')[0] -%}

include:
  - catalog.debian.minimal-templates-installed

"{{ ns }}/11-cloned":
  qvm.clone:
    - require:
      - qvm: catalog.debian.minimal-templates-installed/11-installed
    - source: debian-11-minimal
    - name: tpl-dev-debian-11

"{{ ns }}/12-cloned":
  qvm.clone:
    - require:
      - qvm: catalog.debian.minimal-templates-installed/12-installed
    - source: debian-12-minimal
    - name: tpl-dev-debian-12
