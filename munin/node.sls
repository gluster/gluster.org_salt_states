{% set munin_node = salt['grains.filter_by']({
      'RedHat':  {'pkg': 'munin-node', 'service': 'munin-node', 'config_path': "/etc/munin/",           'log_dir': "munin-node", 'group': "root" },
      'FreeBSD': {'pkg': 'munin-node', 'service': 'munin-node', 'config_path': "/usr/local/etc/munin/", 'log_dir': "munin"     , 'group': "wheel" },
   }, default='RedHat')
%}

munin-node:
  pkg:
    - installed
    - name: {{ munin_node.pkg }}
  service:
    - running
    - name: {{ munin_node.service }}
    - enable: True
    - require:
      - pkg: {{ munin_node.pkg }}
  grains:
    - list_present
    - value: munin-node
    - name: roles
  file:
    - managed
    - source: salt://munin/munin-node.conf
    - name: {{ munin_node.config_path }}/munin-node.conf
    - template: jinja
    - context:
      log_dir: {{ munin_node.log_dir }}
      group: {{ munin_node.group }}
    - watch_in:
        - service: {{ munin_node.service }}
{% if grains['kernel'] == 'Linux' %}
  iptables:
    - insert
    - table: filter
    # remove once 2015 is out
    - match: tcp
    - chain: INPUT
    - dport: 4949
    # TODO do not hardcode
    - source: 104.130.25.92
    - protocol: tcp
    - jump: ACCEPT
    - position: 2
{% endif %}
{% if grains['kernel'] == 'FreeBSD' %}
configure munin on Freebsd:
  cmd:
    - run
    - cwd: /
    - name: /usr/local/sbin/munin-node-configure --shell | sh -x
    - creates: /usr/local/etc/munin/plugins/uptime
{% endif %}

