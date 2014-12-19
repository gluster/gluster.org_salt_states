include:
  - httpd.server


# /etc/httpd/conf/httpd.conf see how we can integrate any modification

# /etc/httpd/conf.d/ilbot.conf
# /etc/httpd/conf.d/mediawiki_upload_security.conf

#TODO notify apache to reload
web_configuration:
  file:
    - managed
    - source: salt://web_server/ssl_custom.conf
    - name: /etc/httpd/conf.d/ssl_custom.conf

{% for domain in ['www', 'blog'] %}
{{ domain }}.gluster.org_http_config:
  file:
    - managed
    - source: salt://web_server/{{ domain }}.gluster.org.conf
    - name: /etc/httpd/conf.d/{{ domain }}.gluster.org.conf
    - template: jinja
    - context:
        ssl: False
        port: 8080

{{ domain }}.gluster.org_https_config:
  file:
    - managed
    - source: salt://web_server/{{ domain }}.gluster.org.conf
    - name: /etc/httpd/conf.d/{{ domain }}.gluster.org_ssl.conf
    - template: jinja
    - context:
        ssl: True
        port: 443
{% endfor %}
 
