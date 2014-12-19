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

{% for port in ['443', '8080'] %}
{% for domain in ['www', 'blog'] %}
{{ domain }}.gluster.org_http{% if port == '443'%}s{% endif %}_config:
  file:
    - managed
    - source: salt://web_server/{{ domain }}.gluster.org.conf
    - name: /etc/httpd/conf.d/{{ domain }}.gluster.org{% if port == '443'%}_ssl{% endif %}.conf
    - template: jinja
    - context:
        ssl: {% if port == '443'%}True{% else %}False{% endif %}
        port: {{ port }}
{% endfor %}
{% endfor %}
 
