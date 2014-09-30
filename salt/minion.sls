salt-minion:
  pkg:
    - installed
  service:
    - running
    - require:
      - pkg: salt-minion

