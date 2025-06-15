{#
#}

{%- set ns = slsdotpath + '.' + tplfile.split('/')[-1].split('.')[0] -%}

{%- set src_tpl = 'debian-12-minimal' -%}

include:
  - catalog.dom0.templates_debian_minimal_installed

"{{ ns }}/tpl-sys-usb-cloned":
  qvm.clone:
    - require:
        - qvm: catalog.dom0.templates_debian_minimal_installed/template-{{ src_tpl }}-installed
    - source: {{ src_tpl }}
    - name: tpl-sys-usb-debian-12
