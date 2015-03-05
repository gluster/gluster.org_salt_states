{% for admin in pillar['admins'] %}
admin_{{ admin }}_authkeys:
  ssh_auth:
    - present
    - user: root
    - names:
      {% for key in admin.ssh_keys %}
      - {{ key }}
      {% endfor %}
{% endfor %}
