include:
  - webbuilder.builder_common

middleman_builder:
  pkg:
    - installed
    - names:
      - rubygem-bundler
      - ruby-devel
      - git
      - make
      - gcc
      - gcc-c++
      - ImageMagick
      - mutt
      - patch
      - libcurl-devel
      - zlib-devel
  user: 
    - present
    - name: middleman_builder 
    - fullname: Middleman builder user
    - home: /srv/middleman_builder/

{% for branch in pillar['middleman_git_branch'] %}
middleman_builder_{{ branch }}:
  git:
    - latest
    - name:  git://forge.gluster.org/gluster-site/gluster-site.git
    - target: /srv/middleman_builder/website_{{ branch }}
    - user: middleman_builder
    - submodules: True
    - rev: {{ branch }}
  file:
    - managed
    - source: salt://webbuilder/config.sh
    - name: /srv/middleman_builder/middleman_{{ branch }}.sh
    - user: middleman_builder
    - group: middleman_builder
    - mode: 644
    - template: jinja
    - context:
        name: website_{{ branch }}
        result_dir: build
        build_command: "bundle install && bundle exec middleman build"
        remote: deploy_website@www.gluster.org:/var/www/middleman_website/{{ branch }}
        branch: {{ branch }}
        email_error: mscherer@redhat.com
# for ssh keys
  cmd:
    - run
    - user: middleman_builder
    - creates: /srv/middleman_builder/.ssh/website_{{ branch }}_id.rsa
    - name: ssh-keygen -N "" -q -f /srv/middleman_builder/.ssh/website_{{ branch }}_id.rsa -t dsa

# TODO create the remote user
# create the ssh keys on this side
# put it in a grain on the other side
# share the setting
  cron:
    - present
    - name: /usr/local/bin/build_deploy.common.sh /srv/middleman_builder/middleman_{{ branch }}.sh
    - minute: '*/5'
    - user: middleman_builder
{% endfor %}

# TODO need to refactor
middleman_builder_planet:
  git:
    - latest
    - name:  https://github.com/gluster/planet-gluster.git
    - target: /srv/middleman_builder/planet
    - user: middleman_builder
    - submodules: True
  file:
    - managed
    - source: salt://webbuilder/config.sh
    - name: /srv/middleman_builder/planet.sh
    - user: middleman_builder
    - group: middleman_builder
    - mode: 644
    - template: jinja
    - context:
        name: planet
        result_dir: build
        build_command: "bundle install && bundle exec middleman build"
        remote: deploy_website@www.gluster.org:/var/www/planet/
        branch: master
        email_error: mscherer@redhat.com
# for ssh keys
  cmd:
    - run
    - user: middleman_builder
    - creates: /srv/middleman_builder/.ssh/planet_id.rsa
    - name: ssh-keygen -N "" -q -f /srv/middleman_builder/.ssh/planet_id.rsa -t dsa

# TODO create the remote user
# create the ssh keys on this side
# put it in a grain on the other side
# share the setting
  cron:
    - present
    - name: /usr/local/bin/build_deploy.common.sh /srv/middleman_builder/planet.sh
    - minute: '*/5'
    - user: middleman_builder


# TODO create the remote user
# create the ssh keys on this side
# put it in a grain on the other side

