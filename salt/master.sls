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

# TODO set the permission on the directory
git:
  pkg:
    - .installed:
  file.directory:
    - name: /srv/git_repos

git_repos:
  file.directory:
    - mode: 755
    - owner: root
# TODO group
    - names:
{% for repo in git_repos %}
      - /srv/git_repos/{{ repo.name }}
{% endfor %}

  git.present:
    - names:
# uncomment once first version in 2015 is out, with
# https://github.com/saltstack/salt/pull/19046
#   - shared: group
{% for repo in git_repos %}
      - /srv/git_repos/{{ repo.name }}
{% endfor %}

deploy_script:
  file:
    - managed
    - mode: 755
    - name: /usr/local/bin/deploy_salt.sh
    - source: salt://salt/deploy_salt.sh

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
    - contents: '%admins ALL=(ALL) NOPASSWD: /usr/local/bin/deploy_salt.sh'

# TODO
#  make sure the repo used the shared options
