{#
#}

{% if grains['id'] is match('^tpl-dev-fedora-(39|40|41)$') %}

"{{ slsdotpath }}.installed-dnf-plugins-core":
  pkg.installed:
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
        - git
        - pkgconf-pkg-config
        - dnf-plugins-core
{# on Fedora pkg-config is pkgconf-pkg-config #}

"{{ slsdotpath }}.installed-dnf-builddep-python3":
  cmd.run:
    - require: [{pkg: "{{ slsdotpath }}.installed-dnf-plugins-core"}]
    - name: dnf -y builddep python3

{% endif %}
