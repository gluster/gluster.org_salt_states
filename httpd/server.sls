mod_ssl:
  pkg:
    - installed

httpd:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - require:
      - pkg: httpd
      - pkg: mod_ssl

{% if grains['osmajorrelease'] == 7 and grains['kernel'] == 'Linux' and grains['os_family'] == 'RedHat' %}
httpd_firewalld:
  firewalld:
    - present
    - name: public
      - ports:
        - 80/tcp
        - 443/tcp
{% endif %}

ssl_configuration:
  file:
    - managed
    - source: salt://web_server/ssl_custom.conf
    - name: /etc/httpd/conf.d/ssl_custom.conf
    - watch_in:
        - service: httpd
 

