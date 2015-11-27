add_nfs_service:
  runner.state.orchestrate:
    - mods: freeipa.add_service_keytab
    - pillar:
        target: {{ data['server'] }}
        service: nfs
        calling_state: nfs.server

