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

{% for name in salt['mine.get']('roles:munin-node', 'test.ping', expr_form='grain').items() %}

config_{{ name }}:
  file:
    - managed
    - name: /etc/munin/conf.d/{{ name }}.conf
    - contents: "
      [{{ name }}]
        address {{ name }}
        use_node_name yes"
{% endfor %}
