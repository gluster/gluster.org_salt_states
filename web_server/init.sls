include:
  - httpd.server


# /etc/httpd/conf/httpd.conf voir quel modif
# ajout /etc/httpd/conf.d/sslv3_cve.conf

# /etc/httpd/conf.d/www.gluster.org.conf
# /etc/httpd/conf.d/www.gluster.org_ssl.conf

# /etc/httpd/conf.d/ilbot.conf
# /etc/httpd/conf.d/blog.gluster.org_ssl.conf
# /etc/httpd/conf.d/blog.gluster.org.conf
# /etc/httpd/conf.d/mediawiki_upload_security.conf

web_configuration:
  file: 
    - managed
    - source: salt://web_server/sslv3_cve.conf
    - name: /etc/httpd/conf.d/sslv3_cve.conf
