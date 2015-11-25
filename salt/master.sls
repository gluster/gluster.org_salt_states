{% from "salt/git_repos.jinja" import git_repos with context %}

salt-master:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - require:
      - pkg: salt-master
  cron.present:
    - user: root
    - minute: '*/30'
    - name: salt -t 60 '*' state.highstate

master_d:
  file:
    - directory
    - name: /etc/salt/master.d/

reactor:
  file:
    - managed
    - name: /etc/salt/master.d/reactor.conf
    - source: salt://salt/reactor.conf
    - watch_in:
      - service: salt-master

{% for port in ['4505', '4506'] %}
open_port_{{ port }}:
  iptables:
    - append
    - table: filter
    # remove once 2015 is out
    - match: tcp
    - chain: INPUT
    - dport: {{ port }}
    - protocol: tcp
    - jump: ACCEPT
{% endfor %}

# TODO set the permission on the directory
git:
  pkg:
    - installed
  file.directory:
    - name: /srv/git_repos

{% for repo in git_repos %}
git_repos_{{ repo.name }}:
  file.directory:
    {% if repo.public %}
    - mode: 2775
    {% else %}
    - mode: 2770
    {% endif %}
    - user: root
# TODO put the group in a pillar
    - group: admins
    - names:
      - /srv/git_repos/{{ repo.name }}
  git.present:
    - names:
      - /srv/git_repos/{{ repo.name }}
    - shared: group
{% endfor %}

{% for script in ['deploy_salt.sh', 'list_old_minions.py' ] %}
{{ script }}:
  file:
    - managed
    - mode: 755
    - name: /usr/local/bin/{{ script }}
    - source: salt://salt/{{ script }}
{% endfor %}

post_receive_scripts:
  file:
    - managed
    - mode: 755
    - names:
{% for repo in git_repos %}
      - /srv/git_repos/{{ repo.name }}/hooks/post-receive
{% endfor %}
    - source: salt://salt/post-receive

post_receive_sudoers:
  pkg.installed:
    - name: sudo
  file:
    - managed
    - name: /etc/sudoers.d/admins
    - source: salt://salt/admins.sudoers

include:
  - .cloud
# TODO
#  make sure the repo used the shared options
