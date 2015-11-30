{% if salt['pillar.get']('export_nfs:' + grains['fqdn'], []) %}
include:
  - .common

# detect if there is a keytab, and if not, trigger a creation 
{% if not salt['cmd.retcode']('klist -K -k /etc/krb5.keytab | grep nfs/' + grains['fqdn'] + '@') %}
create_keytab_ipa_side:
  event:
    - wait
    - name: gluster/freeipa/add_nfs_service
    - data:
        server: {{ grains['fqdn'] }}

{% else %}
nfs_services:
  service:
    - running
    - enable: True
    - require:
      - pkg: nfs-utils
    - names:
      - nfs-server
      - nfs-server-secure

/etc/exports:
  file:
    - managed
    - mode: 644
    - user: root
    - group: root
    - contents: |
          {% for exports in salt['pillar.get']('export_nfs:' + grains['fqdn'], []) %}
          {{ export.path }} {{ export.netmask|default('*')}}({% if export.get('readonly',True) %}ro{% else %}rw{% endif %},sec=krb5,no_subtree_check,no_root_squash)
          {% endfor %}
refresh_export:
  cmd.wait:
    name: exportfs  -r -v
    watch:
      file: /etc/exports
{% endif %}
{% endif %}
