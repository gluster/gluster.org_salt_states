postgrey:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - require:
      - pkg: postgrey


