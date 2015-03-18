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
  iptables:
    - append
    - chain: INPUT
    - port: 4949
    # TODO do not hardcode
    - source: 104.130.25.92
    - protocol: tcp
    - jump: ACCEPT
