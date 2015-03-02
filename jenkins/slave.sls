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
