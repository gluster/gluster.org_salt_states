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

{% for item in ['all','default'] %}
net.ipv6.{{ item }}.disable_ipv6:
  sysctl.present:
    - value: "1"
{% endfor %}

disable_ipv6_modprobe:
  file.managed:
    - name: /etc/modprobe.d/ipv6.conf
    - contents: install ipv6 /bin/true
{% endif %}
