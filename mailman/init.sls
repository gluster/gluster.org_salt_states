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

{% for list in pillar["mailing_lists"] %}
create_{{ list }}:
  cmd:
    - run
    - name: /usr/lib/mailman/bin/newlist {{ list }} listmaster@{{ grains['domain'] }} {{ list }}
    - creates: /var/lib/mailman/lists/{{ list }}/config.pck
{% end %}
