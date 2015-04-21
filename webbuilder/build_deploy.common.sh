#!/bin/bash

export PATH="/usr/local/bin:$HOME/bin:$PATH"
CONFIG=$1
source $CONFIG

LOCKFILE=${XDG_RUNTIME_DIR:-~}/lock_${NAME}
if [ -f $LOCKFILE ]; then
    exit 0
fi

date > $LOCKFILE

DIR="$HOME/$NAME"
cd $DIR
git fetch -q

if [ $( git diff --name-only origin/${BRANCH:-master} | wc -l ) -eq 0 -a ! -f ~/git_updated_${NAME} ]; then
  rm -f $LOCKFILE
  exit 0
fi

touch  ~/git_updated_${NAME}
git pull --rebase
git submodule update
eval $BUILD_COMMAND >  ~/error_${NAME} 2>&1


if [ $? -ne 0 ]; then
    if [ -n "$EMAIL_ERROR" ]; then
        echo "Build failed for $NAME" | EMAIL=nobody@gluster.org mutt -s "Build failed for $NAME" $EMAIL_ERROR -a ~/error_${NAME}
    fi
    rm -f $LOCKFILE
    exit 1
fi

rm -f ~/error_${NAME}
if [[ ! -z $REMOTE ]] ; then
    rsync -e "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i $HOME/.ssh/${NAME}_id.rsa" -rqavz $DIR/$RESULT_DIR/ $REMOTE/
else
    bundle exec middleman deploy
fi;

date > ~/last_update_$NAME
rm -f $LOCKFILE ~/git_updated_${NAME}
