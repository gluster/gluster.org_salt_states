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
  file.managed:
    - name: /etc/ssh/sshd_config
    - mode: 644
    - user: root
{% if grains['kernel'] == 'Linux' %}
    - group: root
{% else %}
    # freebsd
    - group: wheel
{% endif %}
    - check_cmd: sshd -t -f
    - contents: |
          Port {{ salt['pillar.get']('ssh_port:' + grains['fqdn'], '22') }}
          AuthorizedKeysFile .ssh/authorized_keys
          ChallengeResponseAuthentication no
          PasswordAuthentication {{ salt['pillar.get']('ssh_password_auth:' + grains['fqdn'], 'yes') }}
          PermitRootLogin without-password
          PrintMotd yes
          LogLevel {{ salt['pillar.get']('ssh_log_level:' + grains['fqdn'], 'INFO') }}
{% if grains['kernel'] == 'Linux' %}
          Subsystem sftp /usr/libexec/openssh/sftp-server
{% else %}
          Subsystem sftp /usr/libexec/sftp-server
{% endif %}          
          UseDNS no
          UsePAM yes
          HostKey /etc/ssh/ssh_host_rsa_key
          {% if ( grains['osmajorrelease'][0] == '6' or grains['osmajorrelease'][0] == '5' ) and grains['os_family'] == 'RedHat' %}
          UsePrivilegeSeparation yes
          Hostkey /etc/ssh/ssh_host_dsa_key
          {% else %}
          UsePrivilegeSeparation sandbox
          HostKey /etc/ssh/ssh_host_ecdsa_key
          {% endif %}


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
