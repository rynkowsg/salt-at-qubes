example1:
  cmd.run:
    - name: |
        echo "qubes:type - {{ salt['pillar.get']('qubes:type', 'not known') }}"
        echo "master:minion_id - {{ salt['pillar.get']('master:minion_id', 'not known') }}"
