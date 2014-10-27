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
  file:
    - name: /usr/local/bin/build_deploy.sh
    - managed
    - mode: 755
    - source: salt://middleman/build_deploy.sh
  user: 
    - present
    - name: middleman_builder 
    - fullname: Middleman builder user
    - home: /srv/builder/
{% for branch in ['master'] %}
  git:
    - latest
    - name:  git://forge.gluster.org/gluster-site/gluster-site.git
    - target: /srv/builder/website_{{ branch }}
    - user: middleman_builder
    - submodules: True
    - rev: {{ branch }}
# TODO create the remote user
# create the ssh keys on this side
# put it in a grain on the other side
# share the setting
  cron:
    - present
    - name: /usr/local/bin/build_deploy.sh website_{{ branch }} deploy_website@www.gluster.org:/var/www/middleman_website/{{ branch }}  HEAD mscherer@redhat.com
    - minute: '*/5'
    - user: middleman_builder
{% endfor %}
