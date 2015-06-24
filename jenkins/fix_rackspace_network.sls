disable_hosts:
  file.replace:
    - name: /etc/hosts
    - pattern: ^(10\.|2001:)
    - repl:
{% if grains['kernel'] == 'Linux' %}
enable_eth0:
  file.replace:
    - name: /etc/sysconfig/network-scripts/ifcfg-eth0
    - pattern: ^ONBOOT=no
    - repl: ONBOOT=yes

disable_eth1:
  file.replace:
    - name: /etc/sysconfig/network-scripts/ifcfg-eth1
    - pattern: ^ONBOOT=yes
    - repl: ONBOOT=no
{% endif %}
