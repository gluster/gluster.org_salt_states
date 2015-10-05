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

#
# quick dirty hack, likely not doing what I want
#
work_around_firewalld:
  file:
    - managed
    - name: /etc/firewalld/services/freeipa-ldaps.xml
    - contents: |
           <?xml version="1.0" encoding="utf-8"?>
           <service>
           <short>FreeIPA with LDAPS</short>
             <description>FreeIPA is an LDAP and Kerberos domain controller for Linux systems. Enable this option if you plan to provide a FreeIPA Domain Controller using the LDAPS protocol. You can also enable the 'freeipa-ldap' service if you want to provide the LDAP protocol. Enable the 'dns' service if this FreeIPA server provides DNS services and 'freeipa-replication' service if this FreeIPA server is part of a multi-master replication setup.</description>
             <port protocol="tcp" port="80"/>
             <port protocol="tcp" port="443"/>
             <port protocol="tcp" port="88"/>
             <port protocol="udp" port="88"/>
             <port protocol="tcp" port="464"/>
             <port protocol="udp" port="464"/>
             <port protocol="udp" port="123"/>
             <port protocol="tcp" port="636"/>
           </service>
    - watch_in:
        - cmd: firewalld_reload
  cmd:
    - wait
    - name: firewall-cmd --add-service=freeipa-ldaps  --permanent
    - watch:
        - file: /etc/firewalld/services/freeipa-ldaps.xml
    - watch_in:
        - cmd: firewalld_reload
  
