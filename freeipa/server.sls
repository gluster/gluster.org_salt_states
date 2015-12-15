include:
  - firewalld

freeipa:
  pkg:
    - installed
    - name: ipa-server
  cmd:
    - run
    - creates: /etc/ipa/default.conf
    # need tun run it as permissive, since it otherwise fail at the end with this AVC:
    # type=AVC msg=audit(1443714285.363:1382): avc:  denied  { read } for  pid=17447 comm="httpd" scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:system_r:unconfined_service_t:s0 tclass=key
    # see https://bugzilla.redhat.com/show_bug.cgi?id=1268141
    - name: setenforce 0 && ipa-server-install -r {{ pillar['project_domain'] | upper }} -n {{ pillar['project_domain'] }} -p {{ pillar['passwords']['directory_admin'] }}  -U -a {{ pillar['passwords']['kerberos_admin'] }} && setenforce 1
    # uncomment when 2015.8 is in epel, so we can use this module
    # and when 7.2 is out too, since freeipa-ldaps service is in 7.2
#  firewalld:
#    - present
#    - name: public
#    - services:
#      - freeipa-ldaps
create_admin_keytab:
  cmd:
    - run
    - creates: /etc/ipa/admin.keytab
    - name: ipa-getkeytab -s localhost -k /etc/ipa/admin.keytab -p admin@{{ pillar['project_domain'] | upper }} -D "cn=Directory Manager"  -w "{{ pillar['passwords']['directory_admin'] }}"
 
