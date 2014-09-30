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
