{#
#}

{% set ns = slsdotpath + '.' + tplfile.split('/')[-1].split('.')[0] %}

{% if grains['os_family']|lower == 'debian' -%}

{% elif grains['os_family']|lower == 'redhat' -%}

#
# REGARDING THE IMPLEMENTATION:
#
# Initially I used the 'dnf builddep', but later I decided to list
# packages explicitly to avoid running 'dnf builddep' unnecessarily.
#

# include:
#   - catalog.fedora.pkg_dnf_plugins_core_installed
#
# "{{ ns }}/default":
#   cmd.run:
#     - require:
#       - pkg: catalog.fedora.pkg_dnf_plugins_core_installed/default
#     - name: dnf -y builddep python3

"{{ ns }}/default":
  pkg.installed:
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
      - autoconf
      - bluez-libs-devel
      - bzip2
      - bzip2-devel
      - expat-devel
      - gdb
      - gdbm-devel
      - glibc-all-langpacks
      - gmp-devel
      - libX11-devel
      - libappstream-glib
      - libb2-devel
      - libffi-devel
      - libnsl2-devel
      - libtirpc-devel
      - libuuid-devel
      - mesa-libGL-devel
      - mpdecimal-devel
      - ncurses-devel
      - net-tools
      - openssl-devel
      - python-rpm-macros
      - python-setuptools-wheel
      - python-wheel-wheel
      - python3-rpm-generators
      - readline-devel
      - sqlite-devel
      - tcl-devel
      - tix-devel
      - tk-devel
      - valgrind-devel
      - xz-devel
      - zlib-devel

# You can generate that list in a fresh Fedora system with:
#
#     echo n | dnf --setopt=tsflags=test builddep python3 \
#        | awk '/^Installing:/ {p=1} /^Installing dependencies/ {p=0} p && NF && $1 != "Installing:" {print "  - "$1}'
#

{% endif %}
