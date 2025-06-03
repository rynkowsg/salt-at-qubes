## why this works
#
#{% set pillar_val = salt['pillar.get']('qubes:type', 'not known') -%}
#
#example1:
#  cmd.run:
#    - name: echo {{ pillar_val }}
#
## but this doesnt?
#
#example2:
#  cmd.run:
#    - name: echo {{ pillar.get("qubes:type", "PILLAR NOT SET") }}
