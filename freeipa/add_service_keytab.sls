#TODO do not hardcode the server name
{% set freeipa_server = 'freeipa01.rax.gluster.org' %}

get_kerberos_ticket:
  salt.function:
    - name: cmd.run
    - tgt: {{ freeipa_server }}
    - arg:
      - kinit -k -t /etc/ipa/admin.keytab admin@{{ pillar['project_domain'] | upper }}

add_service_nfs:
  salt.function:
    - name: cmd.run
    - tgt: {{ freeipa_server }}
    - arg:
      - ipa service-add {{ pillar['service'] }}/{{ pillar['target'] }}

enroll_client:
  salt.function:
    - name: cmd.run
    - tgt: {{ pillar['target'] }}
    - arg:
      - ipa-getkeytab -s {{ pillar['target'] }} -p {{ pillar['service'] }}/{{ pillar['target'] }} -k /etc/krb5.keytab 

destroy_kerberos_ticket:
  salt.function:
    - name: cmd.run
    - tgt: {{ freeipa_server }}
    - arg:
      - kdestroy

re_run_deployment:
  self.function:
    - name: state.sls
    - tgt: {{ pillar['target'] }}
    - arg:
      - {{ pillar['calling_state'] }}
