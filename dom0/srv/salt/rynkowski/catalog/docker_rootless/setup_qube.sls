{#
#}

{% set ns = slsdotpath + '.' + tplfile.split('/')[-1].split('.')[0] %}

"{{ ns }}/rootless_docker_installed":
  cmd.run:
    - name: dockerd-rootless-setuptool.sh install
    - runas: user
    - unless: test -S /run/user/1000/docker.sock
    - env:
        - XDG_RUNTIME_DIR: /run/user/1000

"{{ ns }}/validate-installation":
  cmd.run:
    - require: [{cmd: "{{ ns }}/rootless_docker_installed"}]
    - name: docker --version
    - unless: docker --version
