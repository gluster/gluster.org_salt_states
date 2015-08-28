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
  - file:
    - managed
    - mode: 644
    - require:
      - pkg: nginx
    - contents: |

        user  nginx;
        worker_processes  1;
        # TODO
        error_log  /var/log/nginx/error.log warn;
        # TODO
        pid        /var/run/nginx.pid;

        events {
            worker_connections  1024;
        }

        http {
            include       /etc/nginx/mime.types;
            default_type  application/octet-stream;

            log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                              '$status $body_bytes_sent "$http_referer" '
                              '"$http_user_agent" "$http_x_forwarded_for"';

            access_log  /var/log/nginx/access.log  main;

            sendfile        on;
                #tcp_nopush     on;

            keepalive_timeout  65;

            #gzip  on;
            #TODO verify path
            include {{ config_prefix}}/etc/nginx/conf.d/*.conf;
       }
