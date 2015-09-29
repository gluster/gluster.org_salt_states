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

# temporary until we have freeipa
sudoers_upload:
  file:
    - managed
    - name: /etc/sudoers.d/kkeithley
    - contents: |
          kkeithley ALL= ALL



# comment CustomLog logs/access_log combined in /etc/httpd/conf/httpd.conf
#
#
