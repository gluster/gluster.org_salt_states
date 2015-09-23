#!/usr/bin/env python

def get_grains():
    domain =  __salt__['grains.get']('domain')
    grains = {}

    grains['project_domain'] = '.'.join(domain.split('.')[-2:])
    grains['datacenter'] = domain.split('.')[-3]

    return grains

