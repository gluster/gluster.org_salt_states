base:
  'supercolony.gluster.org':
    - varnish
    - web_server
    # needed for wordpress
    - memcached.server
    - middleman.web_server
    - mailman
    - postfix
    - postgrey
    - selinux
  '*':
    - salt.minion
    - base
    - ntp
    - openssh
    - munin.node
  'os_family:RedHat':
    - match: grain
    - yum_cron
  'slave*.cloud.gluster.org':
    - jenkins.slave
  'munin.*':
    - munin.master
  'freebsd0.*':
    - munin.node
    - jenkins.slave
  'salt-master.*':
    - rsyslog.client
    - salt.master
  'webbuilder.*':
    - rsyslog.client
    - middleman.builder
  'ci.gluster.org':
    - libvirt
    - openvpn
  'fedora*.ci.gluster.org':
    - jenkins.slave
  'centos*.ci.gluster.org':
    - jenkins.slave
  # download.gluster.org
  'supercolony-gen1.gluster.org':
    - rsync_bitergia
    - download
  'syslog01.rax.gluster.org':
    - selinux
    - rsyslog.server
  'download01.rax.gluster.org':
    - rsync_bitergia
    - rsyslog.client
    - selinux
    - download
  'freeipa01.rax.gluster.org':
    - selinux
    - freeipa.server
    - rsyslog.client
    - firewalld
  'aide01.rax.gluster.org':
    - selinux
    - rsyslog.client
    - aide
  'jenkins-master01.rax.gluster.org':
    - selinux
    - rsyslog.client
    - jenkins.master
