{% from "salt/git_repos.jinja" import git_repos with context %}

{% set user = 'git_pusher' %}
{% set directory = '/etc/git_pusher' %}
{% set remotes = [
  {"name":'github', "url_prefix":"git@github.com:gluster/gluster.org_salt_"},
] %}

{{ user }}:
  user:
    - present
    - system: True
    - createhome: False
    - home: /var/empty

{{ directory }}:
  file:
    - directory
    - owner: {{ user }}
    - mode: 700

{% for remote in remotes %}
ssh_keys_{{ remote.name }}:
  cmd.run:
    - creates: {{ directory }}/id_{{ remote.name }}
    - name: ssh-keygen -q -P '' -C "key for pushing to {{ remote.name }}" -f {{ directory }}/id_{{ remote.name }}
{% endfor %}

{% for repos in git_repos %}
  {% if repos.public %}
    {% for remote in remotes %}
git_config_{{ repos.name }}_branch_{{ remote.name }}:
  git.config_set:
    name: remote.{{ remote.name }}.url
    value: {{ remote.url_prefix }}{{ repos.name }}.git
    {% endfor %}
  {% endif %}
{% endfor %}

#TODO drop a script for sync

