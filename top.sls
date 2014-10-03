base:
  'supercolony.gluster.org':
    - varnish
  '*':
    - salt.minion
    - base.pkgs
  'salt-master.*':
    - salt.master
