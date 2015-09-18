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
    - home: /srv/middleman_website

{% for host, keysinfo in salt['mine.get']('*', 'custom.ssh_pub_keys').items() %}
{% for key, keyinfo in keysinfo.items() %}
sshkeys_{{ host }}_{{ keyinfo.filename }}:
    ssh_auth:
    - present
    - enc: {{ keyinfo.type }}
    - user: deploy_website
    - options:
      - no-port-forwarding
      - no-agent-forwarding
      - no-X11-forwarding
      - no-pty
      - command="rsync --server -vlogDtprze.isf . /srv/middleman_website/www/{{ keyinfo.project}}/{{ keyinfo.branch }}"
    - names:
      - {{ keyinfo.key }}

destination_{{ host }}_{{ keyinfo.filename }}:
  file:
    - directory
    - user: deploy_website
    - group: root
    - mode: 755
    - name: /srv/middleman_website/www/{{ keyinfo.project}}/{{ keyinfo.branch }}
    - makedirs: true

{% endfor %}
{% endfor %}
