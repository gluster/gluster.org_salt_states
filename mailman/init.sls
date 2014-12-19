mailman:
  pkg:
    - installed
  service:
    - running
    - require:
      - pkg: mailman 
  file:
    - managed
    - name: /etc/mailman/mm_cfg.py
    - source: salt://mailman/mm_cfg.py
    - template: jinja
    - watch_in:
      - service: mailman
    - require:
      - pkg: mailman 
 
