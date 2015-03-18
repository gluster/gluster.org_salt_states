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
  file:
    - managed
    - source: salt://munin/munin-node.conf
    - name: /etc/munin/munin-node.conf 
    - template: jinja
    - watch_in:
        - service: munin-node
