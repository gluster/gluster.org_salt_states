builder_common:
  file:
    - name: /usr/local/bin/build_deploy.sh
    - managed
    - mode: 755
    - source: salt://webbuilder/build_deploy.sh
