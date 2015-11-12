# ouvrir le firewall
# add requisites
include:
  - .common

#TODO set it in the pillar
{% set syslog_server = 'syslog.gluster.org' %}

/etc/rsyslog.d/export_to_central.conf:
  file:
    - managed
    - watch_in:
      - service: rsyslog
    - contents: |

        $ActionSendStreamDriverAuthMode      x509/name
        # TODO fix the location 
        $ActionSendStreamDriverPermittedPeer {{ syslog_server }}
        $ActionSendStreamDriverMode          1 

        $ActionQueueFileName       queue_syslog_{{ syslog_server }} 
        $ActionQueueMaxDiskSpace   1g    # 1gb space limit (use as much as possible)
        $ActionQueueSaveOnShutdown on    # save messages to disk on shutdown
        $ActionQueueType           LinkedList   # run asynchronously
        $ActionResumeRetryCount    -1    # infinite retries if host is down

        *.* @@{{ syslog_server }}:514    # forward everything to remote server

