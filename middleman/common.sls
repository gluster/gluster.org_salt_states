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
  file: 
    - name: /srv/middleman_builder/.bash_profile
    - managed
    - mode: 644
    - contents: 'export PATH="~/bin:$PATH"'
  file:
    - name: /usr/local/bin/build_deploy.common.sh
    - managed
    - mode: 755
    - source: salt://middleman/build_deploy.common.sh
