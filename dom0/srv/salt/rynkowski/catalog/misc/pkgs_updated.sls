{#
#}

{%- set ns = slsdotpath + '.' + tplfile.split('/')[-1].split('.')[0] -%}

"{{ ns }}/default":
{% if grains['os'] == 'Fedora' and grains['osmajorrelease'] >= 41 %}
    cmd.run:
      - name: dnf5 upgrade -y
{% else %}
    pkg.uptodate:
      - refresh: True
{% endif %}
