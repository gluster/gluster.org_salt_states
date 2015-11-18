jenkins:
  pkgrepo:
  - managed
  - humanname: Jenkins
  - require_in:
    - pkg: jenkins
  - gpgcheck: 1
  - baseurl: http://pkg.jenkins-ci.org/redhat/
  # yes, that's on HTTP, not HTTPS...
  #  - key_url: http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
  - keyserver: keys.gnupg.net
  - keyid: 0xD50582E6
  pkg:
  - latest
  - refresh: True
