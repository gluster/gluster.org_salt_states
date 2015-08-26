include:
    - httpd.server

munin-master:
  pkg:
    - installed
    - name: munin
  grains:
    - list_present
    - value: munin-master
    - name: roles

web_configuration:
    file:
    - managed
    - source: salt://munin/vhost.conf
    - name: /etc/httpd/conf.d/{{ salt['grains.get']('nodename') }}.conf
    - watch_in:
        - service: httpd

old_config:
  file:
  - absent
  - name: /etc/httpd/conf.d/munin.conf
  - watch_in:
    - service: httpd

{% for node, data in salt['mine.get']('roles:munin-node', 'test.ping', expr_form='grain').items() %}

config_{{ node }}:
  file:
    - managed
    - template: jinja
    - name: /etc/munin/conf.d/{{ node }}.conf
    - source: salt://munin/node.conf
    - context: 
      node: {{ node }}
{% endfor %}
