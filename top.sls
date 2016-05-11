base:
  'supercolony.gluster.org':
    - varnish
    - web_server
    # needed for wordpress
    - memcached.server
    - middleman.web_server
    - postfix
    - postgrey
    - selinux
  '* and not G@cfgmgmt:ansible':
    - match: compound
    - openssh
    - ntp
  '*':
    - salt.minion
    - base
    - munin.node
  'os_family:RedHat':
    - match: grain
    - yum_cron
  'munin.*':
    - munin.master
  'freebsd0.*':
    - munin.node
  'salt-master.*':
    - salt.master
  'ci.gluster.org':
    - openvpn
  'fedora*.ci.gluster.org':
    - jenkins.slave
  'centos*.ci.gluster.org':
    - jenkins.slave
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
