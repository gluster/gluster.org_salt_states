ntp:
  pkg:
    - installed
  service:
    - names:
      - ntpd 
    - running
    - require:
      - pkg: ntp
