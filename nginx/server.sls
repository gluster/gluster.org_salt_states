{% set config_prefix = salt['grains.filter_by']({ 
      'RedHat': '',
      'FreeBSD': '/usr/local',
   }, default='RedHat') 
%}


nginx:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - require:
      - pkg: nginx
    - watch:
      - file: {{ config_prefix}}/etc/nginx/nginx.conf

{{ config_prefix}}/etc/nginx/conf.d/:
  file:
    - directory
    - dir_mode: 755
    - require:
      - pkg: nginx

# TODO add some configuration file with template for conf.d/
#
#
{{ config_prefix}}/etc/nginx/nginx.conf:
  file:
    - managed
    - mode: 644
    - template: jinja
    - source: salt://nginx/nginx.conf
    - context:
      config_prefix: {{ config_prefix}}
    - require:
      - pkg: nginx

