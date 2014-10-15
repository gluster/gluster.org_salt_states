base:
  'supercolony.gluster.org':
    - varnish.server
    - httpd.server
    # needed for wordpress
    - memcached.server
  '*':
    - salt.minion
    - base.pkgs
  'salt-master.*':
    - salt.master
