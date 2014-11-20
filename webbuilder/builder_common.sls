builder_common:
  file:
    - name: /usr/local/bin/build_deploy.common.sh
    - managed
    - mode: 755
    - source: salt://webbuilder/build_deploy.common.sh
