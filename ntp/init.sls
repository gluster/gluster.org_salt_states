ntp:
  pkg:
    - installed
  service:
    - names:
      - ntpd 
    - running
    - enable: True
    - require:
      - pkg: ntp
