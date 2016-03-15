include:
  - .motd

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
{% if grains['kernel'] == 'Linux' %}
    - require:
      - pkg: openssh-server
{% endif %}
    - watch:
      - file: /etc/ssh/sshd_config

  file.line:
    - name: /etc/ssh/sshd_config
    - content: PermitRootLogin without-password
    - mode: replace

{% if grains['kernel'] == 'Linux' %}
{% if grains['osmajorrelease'] == 7 and grains['kernel'] == 'Linux' and grains['os_family'] == 'RedHat' %}
openssh_firewalld:
  firewalld:
    - present
    - name: public
      - ports:
        - 22/tcp
{% else %}
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
{% endif %}
