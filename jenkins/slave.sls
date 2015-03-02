jenkins_slave:
  pkg.installed:
    - names:
      - cmockery2-devel 
      - dbench 
      - libacl-devel 
      - mock 
      - nfs-utils 
      - yajl 
      - perl-Test-Harness
      - java-1.7.0-openjdk
  user.present:
    - name: mock
    - groups:
      - mock
    - require:
      - pkg: mock
disable_hosts:
  file.replace:
    - name: /etc/hosts
    - pattern: ^(10\.|2001:)
    - repl:
disable_eth1:
  file.replace:
    - name: /etc/sysconfig/network-scripts/ifcfg-eth0
    - pattern: ^ONBOOT=yes
    - repl: ONBOOT=no
disable_ipv6_eth0:
  file.replace:
    - name: /etc/sysconfig/network-scripts/ifcfg-eth0
    - pattern: ^IPV6INIT=yes
    - repl: IPV6INIT=no
disable_ipv6_network:
  file.replace:
    - name: /etc/sysconfig/network
    - pattern: ^NETWORKING_IPV6=yes
    - repl: NETWORKING_IPV6=no
disable_ipv6_sysctl:
  file.append:
    - name: /etc/sysctl.conf
    - text:
      - net.ipv6.conf.all.disable_ipv6 = 1
      - net.ipv6.conf.default.disable_ipv6 = 1
disable_ipv6_modprobe:
  file.managed:
    - name: /etc/modprobe.d/ipv6.conf
    - contents: options ipv6 disable=1
enable_wheel_sudoers:
  file.managed:
    - name: /etc/sudoers.d/sudoers_jenkins
    - contents: '%wheel NOPASSWD: ALL=(ALL)'
# TODO /home in 755 
jenkins_user:
  user.present:
    - name: jenkins
    - groups:
      - wheel
{% for key in pillar['ssh_fingerprints']['review.gluster.org'] %}
jenkins_keys_{{ key.enc }}:
  ssh_known_hosts.present:
    - name: review.gluster.org
    - user: jenkins
    - enc: {{ key.enc }}
    - fingerprint: {{ key.fingerprint }}
    - require:
      - user: jenkins 
{% endfor %}

{% for dir in [ '/var/log/glusterfs', '/var/lib/glusterd', '/var/run/gluster',  '/d/archived_builds', '/d/backends', '/d/build', '/d/logs', '/home/jenkins/root', '/archives/archived_builds', '/archives/log' ] %}
{{ dir }}:
  file.directory:
    - user: jenkins
    - groups: jenkins
    - makedirs: True
    - require:
      - user: jenkins
    - dir_mode: 755
{% endfor %}

/builder:
  file.symlink:
   - target: /d/builder

git://forge.gluster.org/gluster-patch-acceptance-tests/gluster-patch-acceptance-tests.git:
  git.latest:
    - target: /opt/qa

