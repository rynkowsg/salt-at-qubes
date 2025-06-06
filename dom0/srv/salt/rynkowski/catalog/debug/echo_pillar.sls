example1:
  cmd.run:
    - name: |
        echo "qubes:type - {{ salt['pillar.get']('qubes:type', 'not known') }}"
        echo "master:minion_id - {{ salt['pillar.get']('master:minion_id', 'not known') }}"
        echo "templates - {{ salt['pillar.get']('templates', 'not known') }}"

{% for tpl in salt['pillar.get']('templates', []) %}
sample2:
  cmd.run:
  - name: |
      echo "tpl - {{ tpl }}"
{% endfor %}
