{#
#}

include:
  - tpl-fedora-minimal.create

"{{ slsdotpath }}.39-cloned":
  qvm.clone:
    - require: [{sls: tpl-fedora-minimal.create}]
    - source: fedora-39-minimal
    - name: tpl-dev-fedora-39

"{{ slsdotpath }}.40-cloned":
  qvm.clone:
    - require: [{sls: tpl-fedora-minimal.create}]
    - source: fedora-40-minimal
    - name: tpl-dev-fedora-40

"{{ slsdotpath }}.41-removed":
  qvm.absent:
    - name: tpl-dev-fedora-41
# For some reason there are issues with DNF5 on Fedora 41.
# For now I will keep using Fedora 40.
