motd:
  file:
    - managed
    - name: /etc/motd 
    - source: salt://openssh/motd
    - template: jinja
    - context:
        category: {{ salt['pillar.get']('motd:' + grains['fqdn'] + ':category', 'Unspecified') }}
        admin:    {{ salt['pillar.get']('motd:' + grains['fqdn'] + ':admin',    'root@' + grains['domain']  ) }}
        purpose:  {{ salt['pillar.get']('motd:' + grains['fqdn'] + ':purpose',  'Unspecified') }}
