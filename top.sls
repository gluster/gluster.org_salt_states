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
  'os_family:RedHat':
    - match: grain
    - yum_cron
  'slave*.cloud.gluster.org':
    - jenkins.slave
    - munin.node
  'munin.*':
    - munin.master
    - munin.node
  'freebsd0.*':
    - munin.node
  'salt-master.*':
    - salt.master
    - munin.node
  'webbuilder.*':
    - middleman.builder
    - awestruct.builder
