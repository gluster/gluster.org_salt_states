openssh:
  # * BSD have openssh in the base system
{% if grains['kernel'] == 'Linux' %}
  pkg:
    - installed
    - names:
      - openssh-server
      - openssh
{% endif %}
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
{% if grains['kernel'] == 'Linux' %}
openssh_fw:
  iptables:
    - append
    - table: filter
    # remove once 2015 is out
    - match: tcp
    - chain: INPUT
    - dport: 22
    - protocol: tcp
    - jump: ACCEPT
{% endif %}
