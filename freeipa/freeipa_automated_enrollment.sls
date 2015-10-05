/etc/salt/master.d/ipa_enroll.conf:
  file:
    - managed
    - source: salt://freeipa/ipa_enroll.conf
    - watch_in: salt-master
