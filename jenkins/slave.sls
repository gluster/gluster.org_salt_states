jenkins_slave:
  pkg.installed:
    - names:
      - cmockery2-devel 
      - dbench 
      - libacl-devel 
      - mock 
      - nfs-utils 
      - yajl 
      - perl-Test-Harness
      - java-1.7.0-openjdk
  user.present:
    - name: mock
    - groups:
      - mock
    - require:
      - pkg: mock
  file.replace:
    - name: /etc/hosts
    - pattern: ^(10\.|2001:)
    - repl:
  file.replace:
    - name: /etc/sysconfig/network-scripts/ifcfg-eth0
    - pattern: ^IPV6INIT=yes
    - repl: IPV6INIT=no
  file.replace:
    - name: /etc/sysconfig/network
    - pattern: ^NETWORKING_IPV6=yes
    - repl: NETWORKING_IPV6=no

