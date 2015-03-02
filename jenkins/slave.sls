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
  user.present:
    - name: mock
    - groups:
      - mock
    - require:
      - pkg: mock
  
