include:
  - .common

{% set rsyslog_user = 'rsyslogd' %}
{{ rsyslog_user }}:
  user.present:
    - fullname: Rsyslogd user - salt created
    - shell: /bin/sh
    - home: /srv/logs/
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
        $template DynaFileGeneric,"/srv/logs/%HOSTNAME%/%$YEAR%/%$MONTH%/%$DAY%/syslog.log"
        *.* -?DynaFileGeneric
        
        $template DynaFileSecure,"/srv/logs/%HOSTNAME%/%$YEAR%/%$MONTH%/%$DAY%/secure"
        authpriv.* -?DynaFileSecure


#TODO add the firewall opening when firewalld module is supported
