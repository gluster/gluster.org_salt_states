base:
  'supercolony.gluster.org':
    - web_server
    - middleman.web_server
    - postfix
    - postgrey
  '* and not G@cfgmgmt:ansible':
    - match: compound
    - openssh
    - ntp
  '*':
    - salt.minion
    - base
  'salt-master.*':
    - salt.master
  'ci.gluster.org':
    - openvpn
  # download.gluster.org
  'supercolony-gen1.gluster.org':
    - rsync_bitergia
    - download
  'download01.rax.gluster.org':
    - rsync_bitergia
    - rsyslog.client
    - selinux
    - download
    - nfs.server
  'freeipa01.rax.gluster.org':
    - freeipa.server
    - firewalld
  'aide01.rax.gluster.org':
    - selinux
    - rsyslog.client
    - aide
    #  'jenkins-master01.rax.gluster.org':
      #- selinux
      #- rsyslog.client
      #- jenkins.master
