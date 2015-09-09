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


{% for i in ['internal', 'external', 'mailman'] %}
{{ i }}_aliases:
  file:
    - managed
    - name: /etc/postfix/{{ i }}.aliases
    - require:
      - pkg: postfix
    - source: salt://postfix/{{ i }}.aliases
    - template: jinja
  cmd:
    - wait
    - name: postalias {{ i }}.aliases
    - cwd: /etc/postfix
    - watch:
      - file: /etc/postfix/{{ i }}.aliases
{% endfor %}
