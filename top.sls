base:
  'supercolony.gluster.org':
    - varnish.server
    - web_server
    # needed for wordpress
    - memcached.server
    - middleman.web_server
    - mailman
  '*':
    - salt.minion
    - base.pkgs
    - base.ssh_keys
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
  'fedora*.ci.gluster.org':
    - jenkins.slave
