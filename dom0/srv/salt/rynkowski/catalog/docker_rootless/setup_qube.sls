{#
#}

{% set ns = slsdotpath + '.' + tplfile.split('/')[-1].split('.')[0] %}

"{{ ns }}/rootless-docker-installed":
  cmd.run:
    - name: dockerd-rootless-setuptool.sh install
    - unless: test -S /run/user/1000/docker.sock
    - runas: user
    - env:
        - XDG_RUNTIME_DIR: /run/user/1000

"{{ ns }}/installation-validated":
  cmd.run:
    - require:
      - cmd: "{{ ns }}/rootless-docker-installed"
    - name: docker --version
    - unless: docker --version
    - runas: user
    - env:
        - XDG_RUNTIME_DIR: /run/user/1000
