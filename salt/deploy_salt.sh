#!/bin/bash

# TODO fix the path
if  [[ $PWD == /srv/git_repos/* ]]; then
    # only update if run from git
    GIT_WORK_TREE=/srv/salt git checkout -q -f
fi
salt \* state.highstate

