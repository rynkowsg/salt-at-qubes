{#
#}

{%- set ns = slsdotpath + '.' + tplfile.split('/')[-1].split('.')[0] -%}

include:
  - catalog.dom0.install_templates_fedora_minimal

{% for os_version in [39, 40] %}
"{{ ns }}/tpl-dev-fedora-{{ os_version }}-created":
  qvm.clone:
    - require:
        - qvm: catalog.dom0.install_templates_fedora_minimal/fedora-{{ os_version }}-minimal-installed
    - source: fedora-{{ os_version }}-minimal
    - name: tpl-dev-fedora-{{ os_version }}
{% endfor %}

"{{ ns }}/41-removed":
  qvm.absent:
    - name: tpl-dev-fedora-41
# For some reason there are issues with DNF5 on Fedora 41.
# For now I will keep using Fedora 40.
