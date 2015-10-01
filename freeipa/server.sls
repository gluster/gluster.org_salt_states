include:
  - firewalld

freeipa:
  pkg:
    - installed
    - name: ipa-server
  cmd:
    - run
    - creates: /etc/ipa/default.conf
    - name: ipa-server-install -r {{ pillar['project_domain'] | upper }} -n {{ pillar['project_domain'] }} -p {{ pillar['passwords']['directory_admin'] }}  -U -a {{ pillar['passwords']['kerberos_admin'] }}
    # uncomment when 2015.8 is in epel, so we can use this module
    # and when 7.2 is out too, since freeipa-ldaps service is in 7.2
#  firewalld:
#    - present
#    - name: public
#    - services:
#      - freeipa-ldaps
work_around_firewalld:
  file:
     - managed
     - name: /etc/firewalld/services/freeipa-ldaps.xml
     - content: |
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
  cmd:
     - wait
     - name: firewall-cmd --add-service=freeipa-ldaps  --permanent
     - watch_in:
        - cmd: firewalld_reload
  
