{% from "salt/git_repos.jinja" import git_repos with context %}

{% set directory = '/etc/git_pusher' %}
{% set user = '_git_pusher' %}
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

# github requires 1 key per repos
{% for remote in remotes %} 
{% for repo in git_repos %}
ssh_keys_{{ repo.name }}:
  cmd.run:
    - creates: {{ directory }}/id_{{remote.name }}_{{ repo.name }}
    - name: ssh-keygen -q -P '' -C "key for pushing {{ repo.name }} to a remote service" -f {{ directory }}/id_{{ repo.name }}
    # Due to git being too old on EL7, I can't use GIT_SSH
    # https://superuser.com/questions/232373/how-to-tell-git-which-private-key-to-use
    # https://stackoverflow.com/questions/7772190/passing-ssh-options-to-git-clone
  file.managed:
    - mode: 0755
    - name: {{ directory }}/ssh_wrapper_{{ remote.name }}_{{ repo.name }}

{% endfor %}
{% endfor %}

{% for repo in git_repos %}
  {% if repo.public %}
    {% for remote in remotes %}
git_config_{{ repo.name }}_branch_{{ remote.name }}:
  #TODO fix me when new version is out, and use config_set
  git.config:
    - name: remote.{{ remote.name }}.url
    - value: {{ remote.url_prefix }}{{ repo.name }}.git
    - repo: /srv/git_repos/{{ repo.name }}
    {% endfor %}
  {% endif %}
{% endfor %}

push_remotes:
  file:
    - managed
    - mode: 755
    - name: /usr/local/bin/push_remote
    - source: salt://salt/push_remote

# TODO drop a list of folders where to sync
{{ directory }}/repos_to_sync:
  file.managed:
    - mode: 644
    - user: root
    - contents: |
        {% for repo in git_repos %}
          {% if repo.public %}
        /srv/git_repos/{{ repo.name }}
          {% endif %}
        {% endfor %}

{{ directory }}/remotes:
  file.managed:
    - mode: 644
    - user: root
    - contents: |
        {% for remote in remotes %}
        {{ remote.name }}
        {% endfor %}


