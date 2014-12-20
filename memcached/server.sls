memcached:
  pkg:
    - installed
  service:
    - running
  selinux.boolean:
      - name: httpd_can_network_memcache
      - value: True
      - persist: True
