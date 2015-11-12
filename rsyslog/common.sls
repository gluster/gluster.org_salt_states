{% set cert_file='/etc/pki/rsyslog/' + grains['fqdn'] + '.crt' %}
{% set key_file='/etc/pki/rsyslog/' + grains['fqdn'] + '.key' %}
{% set ca_file='/etc/ipa/ca.crt' %}

include:
  - certmonger

rsyslog:
  pkg:
    - installed
    - names:
      - rsyslog
      - rsyslog-gnutls
  service:
    - running
    - enable: True
  file:
    - managed
    - name: /etc/rsyslog.d/common.conf
    - contents: |
        $ModLoad imtcp
        $DefaultNetstreamDriver gtls
        # certificate files
        $DefaultNetstreamDriverCAFile   {{ ca_file }}
        $DefaultNetstreamDriverCertFile {{ cert_file }}
        $DefaultNetstreamDriverKeyFile  {{ key_file }}

      
  cmd:
    - run
    - name: ipa-getcert request -f {{ cert_file }} -k {{ key_file }} -D {{ grains['fqdn'] }} -K host/{{ grains['fqdn'] }}
    - creates: {{ key_file }}

