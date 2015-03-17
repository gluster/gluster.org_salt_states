munin-master:
  pkg:
    - installed
    - name: munin
{% for name in salt['mine.get']('roles:munin-node', 'test.ping', expr_form='grain').items() %}

config_{{ name }}:
  file:
    - managed
    - name: /etc/munin/conf.d/{{ name }}.conf
    - contents: |
      [{{ name }}]
        address {{ name }}
        use_node_name yes
{% endfor %}
