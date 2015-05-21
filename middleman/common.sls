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


