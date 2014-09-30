base:
  '*':
    - salt-minion
    - base_pkg
  'salt-master.*':
    - salt-master
