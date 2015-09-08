postfix:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - require:
      - pkg: postfix

postfix_main_cf:
  file:
    - managed
    - mode: 644
    - name: /etc/postfix/main.cf
    - source: salt://postfix/main.cf
    - template: jinja
    - require:
      - pkg: postfix
