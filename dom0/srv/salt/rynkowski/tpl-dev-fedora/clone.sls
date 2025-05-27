{#
#}

{%- set ns = slsdotpath + '.' + tplfile.split('/')[-1].split('.')[0] -%}

include:
  - catalog.fedora.minimal-templates-installed

"{{ ns }}/39-cloned":
  qvm.clone:
    - require:
        - qvm: catalog.fedora.minimal-templates-installed/39-installed
    - source: fedora-39-minimal
    - name: tpl-dev-fedora-39

"{{ ns }}/40-cloned":
  qvm.clone:
    - require:
        - qvm: catalog.fedora.minimal-templates-installed/40-installed
    - source: fedora-40-minimal
    - name: tpl-dev-fedora-40

"{{ ns }}/41-removed":
  qvm.absent:
    - name: tpl-dev-fedora-41
# For some reason there are issues with DNF5 on Fedora 41.
# For now I will keep using Fedora 40.
