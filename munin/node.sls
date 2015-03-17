mine_functions:
  network.ip_addrs: [eth0]

munin-node:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - require:
      - pkg: munin-node
  grains:
    - list_present
    - value: munin-node
    - name: roles
