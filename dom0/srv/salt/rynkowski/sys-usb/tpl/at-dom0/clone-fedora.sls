{#
#}

{%- set ns = slsdotpath + '.' + tplfile.split('/')[-1].split('.')[0] -%}

{%- set src_tpl_40 = 'fedora-40-minimal' -%}
{%- set src_tpl_41 = 'fedora-41-minimal' -%}

include:
  - catalog.dom0.templates_fedora_minimal_installed

"{{ ns }}/tpl-sys-usb-cloned-{{ src_tpl_40 }}":
  qvm.clone:
    - require:
        - qvm: catalog.dom0.templates_fedora_minimal_installed/template-{{ src_tpl_40 }}-installed
    - source: {{ src_tpl_40 }}
    - name: tpl-sys-usb-fedora-40

"{{ ns }}/tpl-sys-usb-cloned-{{ src_tpl_41 }}":
  qvm.clone:
    - require:
        - qvm: catalog.dom0.templates_fedora_minimal_installed/template-{{ src_tpl_41 }}-installed
    - source: {{ src_tpl_41 }}
    - name: tpl-sys-usb-fedora-41
