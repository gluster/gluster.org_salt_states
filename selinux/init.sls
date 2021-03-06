
selinux_pkgs:
  pkg:
    - installed
    - names:
      - selinux-policy
      - selinux-policy-targeted
      - policycoreutils-python

enforcing:
  selinux:
    - mode
    - require:
      - pkg: selinux-policy
      - pkg: selinux-policy-targeted

/etc/selinux/config:
  file:
    - managed
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: selinux-policy
      - pkg: selinux-policy-targeted
    - contents: |
        # file managed by salt, all changes will be erased
        SELINUX=enforcing
        SELINUXTYPE=targeted


/etc/selinux/semanage.conf:
  file:
    - managed
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: policycoreutils-python
    - contents: |
        # file managed by salt, all changes will be erased
        module-store = direct
        expand-check = 0
        #required on for various .ssh/ keys around
        usepasswd = True
        
