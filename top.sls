base:
  'supercolony.gluster.org':
    - varnish.server
    - httpd.server
    # needed for wordpress
    - memcached.server
    - middleman.web_server
  '*':
    - salt.minion
    - base.pkgs
    - ntp
  'salt-master.*':
    - salt.master
  'webbuilder.*':
    - middleman.builder
