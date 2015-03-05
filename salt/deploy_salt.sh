#!/bin/bash

# TODO fix the path
if  [[ $PWD == /srv/git_repos/* ]]; then
    # only update if run from git
    if [[ $PWD == /srv/git_repos/states* ]]; 
        then export GIT_WORK_TREE=/srv/salt 
    fi;
    if [[ $PWD == /srv/git_repos/pillar* ]]; 
        then export GIT_WORK_TREE=/srv/pillar 
    fi;
    git checkout -q -f
fi
salt \* state.highstate

