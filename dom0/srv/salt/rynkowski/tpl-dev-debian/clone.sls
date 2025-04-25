{#
#}

include:
  - tpl-debian-minimal.create

"{{ slsdotpath }}.11-cloned":
  qvm.clone:
    - require: [{sls: tpl-debian-minimal.create}]
    - source: debian-11-minimal
    - name: tpl-dev-debian-11

"{{ slsdotpath }}.12-cloned":
  qvm.clone:
    - require: [{sls: tpl-debian-minimal.create}]
    - source: debian-12-minimal
    - name: tpl-dev-debian-12
