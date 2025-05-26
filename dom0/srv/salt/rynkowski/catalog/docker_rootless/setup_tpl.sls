{#
#}

{% set ns = slsdotpath + '.' + tplfile.split('/')[-1].split('.')[0] %}

{% if grains['os_family']|lower == 'debian' -%}

{% set gpg_key_path = "/usr/share/keyrings/docker.asc" %}

"{{ ns }}/keyring-installed":
  file.managed:
    - name: {{ gpg_key_path }}
    - source: salt://{{ slspath }}/files/repo/apt/docker.asc
    - mode: '0644'
    - user: root
    - group: root
    - makedirs: True

# Keyring was downloaded with
# curl -fsSL https://download.docker.com/linux/debian/gpg -o docker.asc

"{{ ns }}/repo-installed":
  file.managed:
    - name: /etc/apt/sources.list.d/docker.sources
    - source: salt://{{ slspath }}/files/repo/apt/docker.sources.j2
    - template: jinja
    - context:
        os_codename: {{ grains['oscodename'] }}
        gpg_key_path: {{ gpg_key_path }}
    - mode: '0644'
    - user: root
    - group: root
    - makedirs: True

"{{ ns }}/repo-cache-updated":
  cmd.run:
    - require:
        - file: "{{ ns }}/keyring-installed"
        - file: "{{ ns }}/repo-installed"
    - name: apt-get update
    - unless: apt-cache policy docker-ce

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

"{{ ns }}/repo-installed":
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
        - file: "{{ ns }}/keyring-installed"
        - file: "{{ ns }}/repo-installed"
    - name: dnf makecache
    - unless: dnf repolist | grep -q docker-ce

{% endif -%}

"{{ ns }}/deps-installed":
  pkg.installed:
    - require:
        - file: "{{ ns }}/keyring-installed"
        - file: "{{ ns }}/repo-installed"
        - cmd: "{{ ns }}/repo-cache-updated"
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
        - docker-ce
        - docker-ce-cli
        - docker-ce-rootless-extras
        - containerd.io
        - docker-buildx-plugin
        - docker-compose-plugin

"{{ ns }}/ensure-docker-service-disabled":
  service.disabled:
    - require:
        - pkg: "{{ ns }}/deps-installed"
    - name: docker.service

"{{ ns }}/ensure-docker-socket-disabled":
  service.disabled:
    - require:
        - pkg: "{{ ns }}/deps-installed"
    - name: docker.socket

"{{ ns }}/ip-tables-module-loaded":
  kmod.present:
    - name: ip_tables
