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
    - source: salt://middleman/build_deploy.sh
  user: 
    - present
    - name: middleman_builder 
    - fullname: Middleman builder user
    - home: /srv/builder/
  git:
    - latest
    - name:  git://forge.gluster.org/gluster-site/gluster-site.git
    - target: /srv/builder/website
    - user: middleman_builder
    - submodules: True
  cron:
    - present
    - name: /usr/local/bin/build_deploy.sh gluster root@www.gluster.org:/var/www/staging HEAD mscherer@redhat.com
    - minute: */5
    - user: middleman_builder
