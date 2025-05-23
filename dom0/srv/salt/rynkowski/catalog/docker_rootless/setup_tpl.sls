{#
#}

{% set ns = slsdotpath + '.' + tplfile.split('/')[-1].split('.')[0] %}

{% if grains['os_family']|lower == 'debian' -%}

# TODO

{% elif grains['os_family']|lower == 'redhat' -%}

# Instructions for Fedora:
# https://docs.docker.com/engine/install/fedora/
# https://docs.docker.com/engine/security/rootless/

include:
  - catalog.fedora.dnf_pkg_config_installed
  - catalog.misc.pkgs_updated

"{{ ns }}/repo-installed":
  cmd.run:
    - require:
      - pkg: "catalog.misc.pkgs_updated/default"
      - pkg: "catalog.fedora.dnf_pkg_config_installed/default"
    - unless: test -e /etc/yum.repos.d/docker-ce.repo
    - name: dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

"{{ ns }}/repo-cache-updated":
  cmd.run:
    - require: [{cmd: "{{ ns }}/repo-installed"}]
    - name: dnf makecache
    - unless: dnf repolist | grep -q docker-ce

"{{ ns }}/deps-installed":
  pkg.installed:
    - require: [{cmd: "{{ ns }}/repo-cache-updated"}]
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
        - docker-ce
        - docker-ce-cli
        - containerd.io
        - docker-buildx-plugin
        - docker-compose-plugin

"{{ ns }}/ensure-docker-service-disabled":
  service.dead:
    - require: [{pkg: "{{ ns }}/deps-installed"}]
    - name: docker
    - enable: False  # We want rootless, not system-wide

"{{ ns }}/ip-tables-module-added":
  file.managed:
    - name: /etc/modules-load.d/ip_tables.conf
    - mode: '0644'
    - user: root
    - group: root
    - contents: |
        ip_tables
  # ip_tables is necessary to run

{% endif -%}
