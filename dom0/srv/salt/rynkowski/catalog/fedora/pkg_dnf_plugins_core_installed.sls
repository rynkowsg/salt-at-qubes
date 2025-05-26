{#
#}

{% set ns = slsdotpath + '.' + tplfile.split('/')[-1].split('.')[0] %}

"{{ ns }}/default":
  pkg.installed:
    - install_recommends: False
    - skip_suggestions: True
    - pkgs:
        - dnf-plugins-core
