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
    - salt.master
  'webbuilder.*':
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
