include:
  - httpd.server

{% set homedir_middleman = '/srv/middleman_website' %}
middleman_web_server:
  pkg:
    - installed
    - names:
      - rsync
  user:
    - present
    - name: deploy_website
    - fullname: Middleman deploy user
    - home: {{ homedir_middleman }}
  cmd:
    - wait:
    - name: semanage fcontext -a -t ssh_home_t {{ homedir_middleman }}/.ssh/authorized_keys
    - watch:
      - user: deploy_website

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
      - command="rsync --server -vlogDtprze.isf . {{ homedir_middleman }}/www/{{ keyinfo.project}}/{{ keyinfo.branch }}"
    - names:
      - {{ keyinfo.key }}

destination_{{ host }}_{{ keyinfo.filename }}:
  file:
    - directory
    - user: deploy_website
    - group: root
    - mode: 755
    - name: {{ homedir_middleman }}/www/{{ keyinfo.project}}/{{ keyinfo.branch }}
    - makedirs: true

{% endfor %}
{% endfor %}
