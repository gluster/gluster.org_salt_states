include:
  - webbuilder.builder_common

awestruct_builder:
  pkg:
    - installed
    - names:
      - rubygem-bundler
      - ruby-devel
      - git
      - rubygem-rake
  gem:
    - installed
    - names: 
      - awestruct
    # make sure the version is the latest one
  user: 
    - present
    - name: awestruct_builder 
    - fullname: Awestruct builder user
    - home: /srv/awestruct_builder/
{% for branch in ['master'] %}
awestruct_builder_{{ branch }}:
  git:
    - latest
    - name:  git://forge.gluster.org/gluster-docs-project/gluster-docs-project.git
    - target: /srv/awestruct_builder/checkout_{{ branch }}
    - user: awestruct_builder
    - submodules: True
    - rev: {{ branch }}
  file:
    - managed
    - name: /srv/awestruct_builder/awestruct_{{ branch }}.sh
    - user: awestruct_builder
    - group: awestruct_builder
    - mode: 644
    - template: jinja
    - context:
        result_dir: htmltext
        build_command: "rake gen"
        name: awestruct_{{ branch }}
        remote: HEAD
        branch: {{ branch }}
        email_error: mscherer@redhat.com
# TODO create the remote user
# create the ssh keys on this side
# put it in a grain on the other side
# share the setting
  cron:
    - present
    - name: /usr/local/bin/build_deploy.awestruct.sh awestruct_{{ branch }}.sh
# deploy_website@www.gluster.org:/var/www/awestruct_website/{{ branch }}  HEAD mscherer@redhat.com
    - minute: '*/5'
    - user: awestruct_builder
{% endfor %}
