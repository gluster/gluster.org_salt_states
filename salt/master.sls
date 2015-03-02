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
git_repos:
  pkg.installed:
    - names:
      - git
  file.directory:
    - name: /srv/git_repos

  git.present:
    - names:
# uncomment once first version in 2015 is out, with
# https://github.com/saltstack/salt/pull/19046
#   - shared: group
{% for repo in ['states', 'pillar', 'pillar_private'] %}
      - /srv/git_repos/{{ repo }}
{% endfor %}

deploy_script:
  file:
    - managed
    - mode: 755
    - name: /usr/local/bin/deploy_salt.sh
    - source: salt://salt/deploy_salt.sh

post_receive_sudoers:
  pkg.installed:
    - name: sudo
  file:
    - managed
    - name: /etc/sudoers.d/admins
    - contents: '%admins ALL=(ALL) NOPASSWD: /usr/local/bin/deploy_salt.sh'

# TODO
#  add the script in post-receive that extract everything
#  make sure the repo used the shared options
#  have proper groups set for write access 
