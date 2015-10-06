{% set temp_passwd = salt['random.get_str'](18) %}
#TODO do not hardcode the server name
{% set freeipa_server = 'freeipa01.rax.gluster.org' %}

# https://docs.fedoraproject.org/en-US/Fedora/18/html/FreeIPA_Guide/kickstart.html
declare_client_ipa:
  salt.function:
    - name: cmd.run
    - tgt: {{ freeipa_server }}
    - arg:
      #TODO use password for admin
      - ipa host-add {{target }} --password={{ temp_passwd }}

install_freeipa_client:
  salt.function:
    - name: pkg.installed
    - tgt: {{ target }}
    - arg:
      - ipa-client

enroll_client:
  salt.function:
    - name: cmd.run
    - tgt: {{ target }}
    - arg:
      - ipa-client-install --mkhomedir --domain={{ pillar['project_domain'] }} --server={{ freeipa_server }} -U -w {{ temp_passwd }}
