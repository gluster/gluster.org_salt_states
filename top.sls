base:
  'supercolony.gluster.org':
    - varnish.server
    - httpd.server
  '*':
    - salt.minion
    - base.pkgs
  'salt-master.*':
    - salt.master
