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

jenkins_slave:
  pkg.installed:
    - names:
      - cmockery2-devel 
      - dbench 
      - libacl-devel 
      - nfs-utils 
      - yajl 
{% if grains['kernel'] == 'Linux' %}
      - perl-Test-Harness
{% elif grains['kernel'] == 'FreeBSD' %}
      - perl
{% endif %}
      - java-1.7.0-openjdk
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
    - contents: '%wheel ALL=(ALL) NOPASSWD: ALL'

# TODO /home in 755 
jenkins_user:
  user.present:
    - name: jenkins
    - groups:
      - wheel
    - password: {{ pillar['passwords']['jenkins_builder']['jenkins'] }}

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

nginx:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - require:
      - pkg: nginx
  file.copy:
    - name: /etc/nginx/conf.d/default.conf
    - source: /opt/qa/nginx/default.conf
    - require:
      - pkg: nginx
      - git: git://forge.gluster.org/gluster-patch-acceptance-tests/gluster-patch-acceptance-tests.git
