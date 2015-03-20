#!/usr/bin/python
import os
import yaml

import datetime
import salt.client
import subprocess

MINION_CACHE = "/var/cache/salt/minion_cache.yml"

if os.path.exists(MINION_CACHE):
    cache = yaml.load(open(MINION_CACHE))
else:
    cache = {}

local = salt.client.LocalClient()
current_client = local.cmd('*', 'test.ping')
date_now = int(datetime.datetime.now().strftime("%s"))

for i in current_client:
    if current_client[i]:
        cache[i] = date_now

to_drop = []
current_keys = yaml.load(subprocess.check_output(['salt-key', '--out=yaml']))
for minion in current_keys['minions']:
    if minion in cache:
        last_seen = cache[minion]
        if date_now - int(last_seen) > 60 * 15:
            to_drop.append(minion)
    else:
        # case of a new key just added
        cache[minion] = date_now
        
print "To drop:"
for i in to_drop:
    print "  %s" % i

yaml.dump(cache, open(MINION_CACHE, 'w'))
