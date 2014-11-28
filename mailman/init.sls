mailman:
  pkg:
    - installed
  service:
    - running
    - require:
      - pkg: mailman 
