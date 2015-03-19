{% set saltstack = salt['grains.filter_by']({
      'RedHat':  {'pkg': 'salt-minion', 'service': 'salt-minion', 'config_path': "/etc/salt/"},
      'FreeBSD': {'pkg': 'salt',        'service': 'salt_minion', 'config_path': "/usr/local/etc/salt/"},
   }, default='RedHat')
%}


salt-minion:
  pkg:
    - installed
    - name: {{ saltstack.pkg }}
  service:
    - running
    - enable: True
    - require:
      - pkg: {{ saltstack.pkg }}
    - watch:
      - file: {{ saltstack.config_path }}/minion.d/mine.conf
    - name: {{ saltstack.service }}
  file:
    - managed
    - name: {{ saltstack.config_path }}/minion.d/mine.conf
    - contents: "mine_interval: 60"
