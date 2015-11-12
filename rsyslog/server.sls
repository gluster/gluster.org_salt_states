include:
  - .common

# make sure the $HOME is properly owner
{% set rsyslog_user = 'rsyslogd' %}
{% set logs_dir = '/srv/logs/' %}

{{ rsyslog_user }}:
  user.present:
    - fullname: Rsyslogd user - salt created
    - shell: /bin/sh
    - home: {{ logs_dir }}
    - system: True

/etc/rsyslog.d/listen_tls.conf:
  file:
    - managed
    - watch_in:
      - service: rsyslog
    - contents: |
        $PrivDropToUser  {{ rsyslog_user }}
        $PrivDropToGroup {{ rsyslog_user }}
        
        $InputTCPServerStreamDriverAuthMode x509/name
        $InputTCPServerStreamDriverPermittedPeer *.{{ pillar['project_domain'] }}
        $InputTCPServerStreamDriverMode 1 # run driver in TLS-only mode
        $InputTCPServerRun 514 
        
        #
        $template DynaFileGeneric,"{{ logs_dir }}/%HOSTNAME%/%$YEAR%/%$MONTH%/%$DAY%/syslog.log"
        *.* -?DynaFileGeneric
        
        $template DynaFileSecure,"{{ logs_dir }}/%HOSTNAME%/%$YEAR%/%$MONTH%/%$DAY%/secure"
        authpriv.* -?DynaFileSecure


#TODO add the firewall opening when firewalld module is supported
