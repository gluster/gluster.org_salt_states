{% set username = 'bitergia' %}
{{ username }}:
  user:
    - present
    - fullname: Bitergia user to sync logs
    - home: /srv/{{ username }}
{{ username }}_key:
  ssh_auth:
    - present
    - user: {{ username }}
    - names:
{% for key in pillar['rsync_bitergia']['ssh_keys'] %}
      - {{ key }}
{% endfor %}

copy_cron:
  cron.present:
    - user: root
    - minute: '*/30'
    - name: /bin/cp -f -R /var/log/httpd ~{{ username }}/logs && chown -R {{username }} ~{{ username }}/logs
