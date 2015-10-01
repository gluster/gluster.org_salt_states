freeipa:
  pkg:
    - installed
    - name: ipa-server
  cmd:
    - run
    - creates: /etc/ipa/default.conf
    - name: ipa-server-install -r {{ grains['domain'] | upper }} -n {{ grains['domain'] }} -p {{ pillar['passwords']['directory_admin'] }}  -U -a {{ pillar['passwords']['kerberos_admin'] }}
  firewalld:
    - present
    - name: public
    - services:
      - freeipa-ldaps
