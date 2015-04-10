# public is mean to be used later if we want to enforce permission
# or publish automatically somewhere
{% set git_repos = [
  {"name":"states", "public": True},
  {"name":"pillar", "public": True},
  {"name":"pillar_private", "public": False},
] %}

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

reactor_jenkins:
  file:
    - managed
    - name: /etc/salt/master.d/reactor_jenkins.conf
    - source: salt://salt/reactor_jenkins.conf
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
# uncomment once first version in 2015 is out, with
# https://github.com/saltstack/salt/pull/19046
#   - shared: group
      - /srv/git_repos/{{ repo.name }}
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

salt_cloud:
  pkg:
    - installed
    - name: salt-cloud
  file:
    - managed
    - mode: 700
    - name: /etc/salt/cloud.providers.d/rackspace.conf
    - source: salt://salt/rackspace.conf
    - template: jinja
    - require:
      - pkg: salt-cloud
    - context:
        user:   {{ pillar['cloud']['rackspace']['user'] }}
        tenant: {{ pillar['cloud']['rackspace']['tenant'] }}
        apikey: {{ pillar['cloud']['rackspace']['apikey'] }}
        compute_region: {{ pillar['cloud']['rackspace']['compute_region'] }}

jenkins_profile:
  file:
    - managed
    - mode: 700
    - name: /etc/salt/cloud.profiles.d/jenkins.conf
    - source: salt://salt/jenkins.profile.conf
    - require:
      - pkg: salt-cloud
  
# TODO
#  make sure the repo used the shared options
