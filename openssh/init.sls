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
  file.managed:
    - mode: 644
    - user: root
    - group: root
    - contents: |
        Port 22
        AuthorizedKeysFile .ssh/authorized_keys
        ChallengeResponseAuthentication no
        PasswordAuthentication no
        PermitRootLogin without-password
        PrintMotd no
        Subsystem sftp /usr/lib/ssh/sftp-server
        UseDNS no
        UsePAM yes
        UsePrivilegeSeparation sandbox

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
