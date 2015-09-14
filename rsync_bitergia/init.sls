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

#
## disabled for now, until I figure a better way to do that
#
#copy_cron:
#  cron.present:
#    - user: root
#    - minute: '*/30'
#    - name: cp -R /var/log/httpd ~{{ username }}/logs && chown -R {{username }} ~{{ username }}/logs
