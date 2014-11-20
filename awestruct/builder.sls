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

  file:
    - name: /usr/local/bin/build_deploy.awestruct.sh
    - managed
    - mode: 755
    - source: salt://awestruct/build_deploy.sh
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
# TODO create the remote user
# create the ssh keys on this side
# put it in a grain on the other side
# share the setting
  cron:
    - present
    - name: /usr/local/bin/build_deploy.awestruct.sh checkout_{{ branch }} deploy_website@www.gluster.org:/var/www/awestruct_website/{{ branch }}  HEAD mscherer@redhat.com
    - minute: '*/5'
    - user: awestruct_builder
{% endfor %}

