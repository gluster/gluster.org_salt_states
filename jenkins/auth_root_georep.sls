generate_local_key:
  cmd.run:
    - creates: /root/.ssh/id_georep
    - name: ssh-keygen -q -P '' -C "key for georep test" -f /root/.ssh/id_georep 

deploy_key:
  cmd.wait:
    - name: echo "from=127.0.0.1 $(cat /root/.ssh/id_georep.pub)" >> /root/.ssh/authorized_keys
    - watch:
      - cmd: generate_local_key
    

