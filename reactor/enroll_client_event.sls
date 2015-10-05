{% if data['act'] == 'accept' %}
enroll_client_event:
  local.state.sls:
    - tgt: {{ data['id'] }}
    - arg:
      - freeipa.enroll_client
      - kwarg:
        pillar:
          kerberos_admin_password: {{ pillar['passwords']['kerberos_admin'] }}
{% endif %}

