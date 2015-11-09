{% if data['act'] == 'accept' %}
enroll_client_event:
  runner.state.orchestrate:
    - mods: freeipa.enroll_client
    - pillar:
        target: {{ data['id'] }}
{% endif %}

