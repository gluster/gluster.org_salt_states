base:
  'supercolony.gluster.org':
    - web_server
    - middleman.web_server
    - postfix
    - postgrey
  '*':
    - salt.minion
  'salt-master.*':
    - salt.master
  'ci.gluster.org':
    - openvpn
  # download.gluster.org
  'supercolony-gen1.gluster.org':
    - rsync_bitergia
    - download
  'aide01.rax.gluster.org':
    - selinux
    - rsyslog.client
    - aide
    #  'jenkins-master01.rax.gluster.org':
      #- selinux
      #- rsyslog.client
      #- jenkins.master
