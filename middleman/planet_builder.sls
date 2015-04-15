# TODO need to refactor
{% set name = 'planet' %}
{% set branch = 'master' %}
{% set git_repo = 'https://github.com/gluster/planet-gluster.git' %}
{% set remote = 'deploy_website@www.gluster.org:/var/www/planet/' %}
{% set ssh_key = '/srv/middleman_builder/.ssh/%s_id.rsa' % name %}

middleman_builder_{{ name }}:
  git:
    - latest
    - name:  {{ git_repo }}
    - target: /srv/middleman_builder/{{ name }}
    - user: middleman_builder
    - submodules: True
    - rev: {{ branch }}
  file:
    - managed
    - source: salt://webbuilder/config.sh
    - name: /srv/middleman_builder/{{ name }}.sh
    - user: middleman_builder
    - group: middleman_builder
    - mode: 644
    - template: jinja
    - context:
        name: {{ name }}
        result_dir: build
        build_command: "bundle install && bundle exec middleman build"
        remote: {{ remote }}
        branch: {{ branch }}
        email_error: mscherer@redhat.com
# for ssh keys
  cmd:
    - run
    - user: middleman_builder
    - creates: {{ ssh_key }}
    - name: ssh-keygen -N "" -q -f {{ ssh_key }} -t dsa

# TODO create the remote user
# create the ssh keys on this side
# put it in a grain on the other side
# share the setting
  cron:
    - present
    - name: /usr/local/bin/build_deploy.common.sh /srv/middleman_builder/{{ name }}.sh
    - minute: '*/5'
    - user: middleman_builder


# TODO create the remote user
# create the ssh keys on this side
# put it in a grain on the other side

