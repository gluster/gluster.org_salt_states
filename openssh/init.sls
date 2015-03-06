openssh:
  pkg:
    - installed
    - names:
      - openssh-server
      - openssh
  service:
    - running
    - enable: True
    - name: sshd
    - require:
      - pkg: openssh-server
#    - watch:
#      - file: /etc/ssh/sshd_config
#  file:
#    - replace
#    - name: /etc/ssh/sshd_config
#    - pattern: ^PermitRootLogin
#    - repl: PermitRootLogin=without-password

