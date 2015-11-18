jenkins:
  pkgrepo:
  - managed
  - humanname: Jenkins
  - require_in:
    - pkg: jenkins
  - gpgcheck: 1
  - baseurl: http://pkg.jenkins-ci.org/redhat/
  # yes, that's on HTTP, not HTTPS...
  - gpgkey: http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
  pkg:
  - latest
  - refresh: True
