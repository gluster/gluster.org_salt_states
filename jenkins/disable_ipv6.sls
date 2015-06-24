{% if grains['kernel'] == 'Linux' %}
disable_ipv6_eth0:
  file.replace:
    - name: /etc/sysconfig/network-scripts/ifcfg-eth0
    - pattern: ^IPV6INIT=yes
    - repl: IPV6INIT=no

disable_ipv6_network:
  file.replace:
    - name: /etc/sysconfig/network
    - pattern: ^NETWORKING_IPV6=yes
    - repl: NETWORKING_IPV6=no

disable_ipv6_sysctl:
  file.append:
    - name: /etc/sysctl.conf
    - text:
      - net.ipv6.conf.all.disable_ipv6 = 1
      - net.ipv6.conf.default.disable_ipv6 = 1

disable_ipv6_modprobe:
  file.managed:
    - name: /etc/modprobe.d/ipv6.conf
    - contents: options ipv6 disable=1
{% endif %}
