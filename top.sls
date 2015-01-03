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
    - ntp
  'os_family:RedHat':
    - match: grain
    - yum_cron
  'salt-master.*':
    - salt.master
  'webbuilder.*':
    - middleman.builder
    - awestruct.builder
