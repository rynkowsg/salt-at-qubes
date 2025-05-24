{#
#}

{% set ns = slsdotpath + '.' + tplfile.split('/')[-1].split('.')[0] %}

{% if grains['os_family']|lower == 'debian' -%}

# TODO

###############################################################################

{% elif grains['os_family']|lower == 'redhat' -%}

# Instructions for Fedora:
# https://docs.docker.com/engine/install/fedora/
# https://docs.docker.com/engine/security/rootless/

{% set gpg_key_path = "/etc/pki/rpm-gpg/RPM-GPG-KEY-docker-ce.asc" %}

"{{ ns }}/keyring-installed":
  file.managed:
    - name: {{ gpg_key_path }}
    - source: salt://{{ slspath }}/files/repo/yum/docker-ce.asc
    - mode: '0644'
    - user: root
    - group: root
    - makedirs: True

{% set distro_map = {'CentOS': 'centos', 'Fedora': 'fedora', 'RedHat': 'rhel'} %}
{% set docker_distro = distro_map.get(grains['os'], 'rhel') %}

"{{ ns }}/rpm-repo-installed":
  file.managed:
    - name: /etc/yum.repos.d/docker-ce.repo
    - source: salt://{{ slspath }}/files/repo/yum/docker-ce.repo.j2
    - template: jinja
    - context:
        docker_distro: {{ docker_distro }}
        gpg_key_path: {{ gpg_key_path }}
    - mode: '0644'
    - user: root
    - group: root
    - makedirs: True

"{{ ns }}/repo-cache-updated":
  cmd.run:
    - require:
        - file: "{{ ns }}/rpm-gpg-key-installed"
        - file: "{{ ns }}/rpm-repo-installed"
    - name: dnf makecache
    - unless: dnf repolist | grep -q docker-ce

"{{ ns }}/deps-installed":
  pkg.installed:
    - require:
        - file: "{{ ns }}/rpm-gpg-key-installed"
        - file: "{{ ns }}/rpm-repo-installed"
        - cmd: "{{ ns }}/repo-cache-updated"
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
    - require:
        - pkg: "{{ ns }}/deps-installed"
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
