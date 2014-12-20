memcached:
  pkg:
    - installed
  service:
    - running
    - enable: True
  selinux.boolean:
      - name: httpd_can_network_memcache
      - value: True
      - persist: True
