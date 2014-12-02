salt-minion:
  pkg:
    - installed
  service:
    - running
    - require:
      - pkg: salt-minion
    - watch:
      - file: /etc/salt/minion.d/mine.conf
  file:
    - managed
    - name: /etc/salt/minion.d/mine.conf
    - contents: "mine_interval: 60"

