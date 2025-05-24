{#
#}

{% set ns = slsdotpath + '.' + tplfile.split('/')[-1].split('.')[0] %}

"{{ ns }}/default":
  pkg.uptodate:
    - refresh: True
