freeipa_client:
  pkg:
    - installed
    - name: ipa-client
  cmd:
    - run
    - creates: /etc/ipa/default.conf
    #TODO do not hardcode the server name
    - name: ipa-client-install --domain={{ pillar['project_domain'] }} --server=freeipa01.rax.gluster.org -p admin  -U -w {{ kerberos_admin_password }} 
