{#
#}

{%- set ns = slsdotpath + '.' + tplfile.split('/')[-1].split('.')[0] -%}

include:
  - catalog.dom0.install_templates_debian_minimal

{% for os_version in [11, 12] %}
"{{ ns }}/tpl-dev-debian-{{ os_version }}-created":
  qvm.clone:
    - require:
        - qvm: catalog.dom0.install_templates_debian_minimal/debian-{{ os_version }}-minimal-installed
    - source: debian-{{ os_version }}-minimal
    - name: tpl-dev-debian-{{ os_version }}
{% endfor %}
