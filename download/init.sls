include:
  - httpd.server

custom_log:
  file:
    - managed
    - source: salt://download/custom_log.conf
    - name: /etc/httpd/conf.d/custom_log.conf
    - watch_in:
        - service: httpd

vhost:
  file:
    - managed
    - source: salt://download/download.gluster.org.conf
    - watch_in:
        - service: httpd
    - name: /etc/httpd/conf.d/download.gluster.org.conf

# comment CustomLog logs/access_log combined in /etc/httpd/conf/httpd.conf
#
#
