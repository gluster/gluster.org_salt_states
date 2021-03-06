{% set config_prefix = salt['grains.filter_by']({
      'RedHat': '',
      'FreeBSD': '/usr/local',
   }, default='RedHat')
%}


# TODO
# Copy the Jenkins SSH key from build.gluster.org
# Update hostname ??
# Set the Jenkins password ?
# Install git from RPMForge
# Add the loopback mount point to /etc/fstab
# Reboot
# Add forward and reverse DNS entries for the slave into Rackspace DNS
include:
  - .disable_ipv6
  - .fix_rackspace_network
  - .gluster_qa_scripts
  - nginx.server
  - .auth_root_georep

jenkins_slave:
  pkg.installed:
    - names:
      - dbench 
      - yajl 
{% if grains['kernel'] == 'Linux' %}
      - libacl-devel 
      - nfs-utils 
      - automake
      - autoconf
      - libtool
      - flex
      - bison
      - cmockery2-devel 
      - perl-Test-Harness
      - openssl-devel
      - lvm2-devel
      - sqlite-devel
      - libxml2-devel
      - python-devel
      - userspace-rcu-devel
      - libibverbs-devel 
      - librdmacm-devel
      - libaio-devel
      - psmisc   # needed for smoke.sh using killall
      - net-tools # needed for some tests
      - clang-analyzer
      - golang   # needed for restapi/eventlet
      - golang-github-gorilla-mux-devel
# removed while the package is in testing
#      - golang-github-gorilla-handlers-devel
      - golang-github-gorilla-websocket-devel
      - golang-github-dgrijalva-jwt-go-devel
      - golang-github-Sirupsen-logrus-devel
{% if grains['osfullname'] == 'Fedora' %}
      - java-1.8.0-openjdk
{% else %}
      - java-1.7.0-openjdk
{% endif %}
{% elif grains['kernel'] == 'FreeBSD' %}
      - cmockery2 
      - perl5
      - openjdk8-jre
      - sqlite3
{% endif %}
      - git

{% if grains['kernel'] == 'Linux' %}
jenkins_slave_mock:
  pkg.installed:
    - names:
      - mock
  user.present:
    - name: mock
    - groups:
      - mock
    - require:
      - pkg: mock
{% endif %}

enable_wheel_sudoers:
  file.managed:
{% if grains['kernel'] == 'Linux' %}
    - name: /etc/sudoers.d/sudoers_jenkins
{% elif grains['kernel'] == 'FreeBSD' %}
    - name: /usr/local/etc/sudoers.d/sudoers_jenkins
{% endif %}
    - contents: |
          %wheel ALL=(ALL) NOPASSWD: ALL
          Defaults:%wheel !requiretty

# TODO /home in 755 
jenkins_user:
  user.present:
    - name: jenkins
    - groups:
      - wheel
    - password: {{ pillar['passwords']['jenkins_builder']['jenkins'] }}

{% if grains['kernel'] == 'Linux' %}
profile_sh:
  file.managed:
    - name: /etc/profile.d/gluster_test.sh
    - contents: 'export PATH="$PATH:/build/install/sbin:/build/install/bin"'
{% endif %}

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

/build:
  file.symlink:
   - target: /d/build

nginx_config:
  file.copy:
    - name: {{ config_prefix}}/etc/nginx/conf.d/default.conf
    - source: /opt/qa/nginx/default.conf
    - require:
      - pkg: nginx
      - git: https://github.com/gluster/glusterfs-patch-acceptance-tests.git

kernel.core_pattern:
  sysctl.present:
    - value: "/%e-%p.core"
