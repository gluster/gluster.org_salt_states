include:
  - httpd.server

middleman_web_server:
  pkg:
    - installed
    - names:
      - rsync
  user:
    - present
    - name: deploy_website
    - fullname: Middleman deploy user
    - home: /var/www/middleman_website
# remove once the build is cleaned
  cron:
    - present
    - name: /bin/cp -R -f /var/www/middleman_website/master/* /var/www/staging/
    - minute: '*/5'
    - user: root

{% for host, keysinfo in salt['mine.get']('*', 'custom.ssh_pub_keys').items() %}
{% for key, keyinfo in keysinfo.items() %}
sshkeys_{{ host }}_{{ keyinfo.filename }}:
    ssh_auth:
    - present
    - enc: {{ keyinfo.type }}
    - user: deploy_website
    - names:
      - {{ keyinfo.key }}
{% endfor %}
{% endfor %}
