# configuration to be able to run slat-cloud on rackspace
# to start a jenkins slave and automatically install it
salt_cloud:
  pkg:
    - installed
    - name: salt-cloud
  file:
    - managed
    - mode: 700
    - name: /etc/salt/cloud.providers.d/rackspace.conf
    - source: salt://salt/rackspace.conf
    - template: jinja
    - require:
      - pkg: salt-cloud
    - context:
        user:   {{ pillar['cloud']['rackspace']['user'] }}
        tenant: {{ pillar['cloud']['rackspace']['tenant'] }}
        apikey: {{ pillar['cloud']['rackspace']['apikey'] }}
        compute_region: {{ pillar['cloud']['rackspace']['compute_region'] }}

jenkins_profile:
  file:
    - managed
    - mode: 700
    - name: /etc/salt/cloud.profiles.d/jenkins.conf
    - source: salt://salt/jenkins.profile.conf
    - require:
      - pkg: salt-cloud
 
