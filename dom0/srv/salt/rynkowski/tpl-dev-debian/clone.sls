{#
#}

include:
  - catalog.debian.minimal-templates-installed

"{{ slsdotpath }}.11-cloned":
  qvm.clone:
    - require:
      - qvm: catalog.debian.minimal-templates-installed/11-installed
    - source: debian-11-minimal
    - name: tpl-dev-debian-11

"{{ slsdotpath }}.12-cloned":
  qvm.clone:
    - require:
      - qvm: catalog.debian.minimal-templates-installed/12-installed
    - source: debian-12-minimal
    - name: tpl-dev-debian-12
