include:
  - httpd.server


# /etc/httpd/conf/httpd.conf see how we can integrate any modification

# /etc/httpd/conf.d/ilbot.conf
# /etc/httpd/conf.d/blog.gluster.org_ssl.conf
# /etc/httpd/conf.d/blog.gluster.org.conf
# /etc/httpd/conf.d/mediawiki_upload_security.conf

#TODO notify apache to reload
web_configuration:
  file:
    - source: salt://web_server/ssl_custom.conf
    - name: /etc/httpd/conf.d/ssl_custom.conf
    - managed

 
