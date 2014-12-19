salt-master:
  pkg:
    - installed
  service:
    - running
    - require:
      - pkg: salt-master
  cron.present:
    - user: root
    - minute: '*/30'
    - name: salt -t 60 '*' state.highstate

git_repos:
  pkg.installed:
    - names:
      - git
  file.directory:
    - name: /srv/git_repos
  git.present:
    - names:
{% for repo in ['states', 'pillar', 'pillar_private'] %}
      - /srv/git_repos/{{ repo }}
{% endfor %}

# TODO
#  add the script in post-receive that extract everything
#  make sure the repo used the shared options
#  have proper groups set for write access 
