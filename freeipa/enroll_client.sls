{% set temp_passwd = salt['random.get_str'](18) %}
#TODO do not hardcode the server name
{% set freeipa_server = 'freeipa01.rax.gluster.org' %}

# https://docs.fedoraproject.org/en-US/Fedora/18/html/FreeIPA_Guide/kickstart.html
get_kerberos_ticket:
  salt.function:
    - name: cmd.run
    - tgt: {{ freeipa_server }}
    - arg:
      - kinit -k -t /etc/ipa/admin.keytab admin@{{ pillar['project_domain'] | upper }}

declare_client_ipa:
  salt.function:
    - name: cmd.run
    - tgt: {{ freeipa_server }}
    - arg:
      - ipa host-add {{ pillar['target'] }} --password={{ temp_passwd }}

install_freeipa_client:
  salt.function:
    - name: pkg.install
    - tgt: {{ pillar['target'] }}
    - arg:
      - ipa-client

enroll_client:
  salt.function:
    - name: cmd.run
    - tgt: {{ pillar['target'] }}
    - arg:
      - ipa-client-install --mkhomedir --domain={{ pillar['project_domain'] }} --server={{ freeipa_server }} -U -w {{ temp_passwd }}
