{#
#}

{% set ns = slsdotpath + '.' + tplfile.split('/')[-1].split('.')[0] %}

{% if grains['os_family']|lower == 'debian' -%}

{% elif grains['os_family']|lower == 'redhat' -%}

include:
  - catalog.fedora.dnf_pkg_config_installed

"{{ ns }}/default":
  cmd.run:
    - require:
      - pkg: catalog.fedora.pkg_dnf_plugins_core_installed/default
    - name: dnf -y builddep python3

{% endif %}
