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
        result_dir: htmltext
        build_command: "bundle install && bundle exec middleman build"
        remote: deploy_website@www.gluster.org:/var/www/middleman_website/{{ branch }}
        branch: {{ branch }}
        email_error: mscherer@redhat.com
# for ssh keys
  cmd:
    - run
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


# TODO create the remote user
# create the ssh keys on this side
# put it in a grain on the other side

