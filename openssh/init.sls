openssh:
  pkg:
    - installed
    - names:
      - openssh-server
      - openssh
  service:
    - running
    - enable: True
    - require:
      - pkg: openssh-server
    - watch:
      - file: /etc/ssh/sshd_config
  file:
    - replace
    - name: /etc/ssh/sshd_config
    - pattern: ^PermitRootLogin
    - repl: PermitRootLogin=without-password

