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
{% for repo in ['states', 'pillar', 'pillar_private'] %}
  git.present:
    - name: /srv/git_repos/{{ repo }}
{% endfor %}

# TODO
#  add the others repo
#  add the script in post-receive that extract everything
