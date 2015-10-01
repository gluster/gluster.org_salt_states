firewalld:
  pkg:
    - installed
  service:
    - running
    - enable: True

firewalld_reload:
  cmd:
    - wait
    - name: firewall-cmd --reload

