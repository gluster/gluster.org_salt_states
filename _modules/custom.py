# -*- coding: utf-8 -*-
'''
Custom module for stuff
'''
import glob
import os

def ssh_pub_keys(user='root'):
    ret = {}
    sshdir = os.path.join(os.path.expanduser('~' + user), '.ssh')
    for i in glob.glob( os.path.join(sshdir,'*.pub')):
        for l in open(i,'r+').readlines():
            ssh_type,ssh_key,ssh_comment = l.split()
            ret[os.path.basename(i)] = {
                'type': ssh_type,
                'key': ssh_key,
                'comment': ssh_comment,
                'path': i,
                'filename': os.path.basename(i),
		'user': user,
            }
    return ret
