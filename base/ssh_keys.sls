{% for admin in pillar['admins'] %}
admin_{{ admin }}_authkeys:
  ssh_auth:
    - present
    - user: root
    - names:
      {% for key in pillar['admins'][admin]['ssh_keys'] %}
      - {{ key }}
      {% endfor %}
{% endfor %}
