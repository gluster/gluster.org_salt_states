base:
  '*':
    - salt.minion
    - base.pkgs
  'salt-master.*':
    - salt.master
