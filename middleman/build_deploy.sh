#!/bin/bash
export PATH="/usr/local/bin:/srv/builder/bin:$PATH"
NAME=$1
REMOTE=$2
BRANCH=$3
EMAIL_ERROR=$4

LOCKFILE=${XDG_RUNTIME_DIR:-~}/lock_${NAME}
if [ -f $LOCKFILE ]; then
    exit 0
fi

date > $LOCKFILE

DIR="/srv/builder/$NAME"
cd $DIR
git fetch -q

if [ $( git diff --name-only origin/${BRANCH:-master} | wc -l ) -eq 0 -a ! -f ~/git_updated_${NAME} ]; then
  rm -f $LOCKFILE
  exit 0
fi

touch  ~/git_updated_${NAME}
git pull --rebase
git submodule update
bundle install
bundle exec middleman build > ~/error_${NAME} 2>&1

if [ $? -ne 0 ]; then
    if [ -n "$MAIL" ]; then
        echo "Build failed for $NAME" | EMAIL=nobody@redhat.com mutt -s "Build failed for $NAME" $EMAIL_ERROR -a ~/error_${NAME}
    fi
    rm -f $LOCKFILE
    exit 1
fi

rm -f ~/error_${NAME}
if [[ ! -z $REMOTE ]] ; then
    rsync -e "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i $HOME/.ssh/${NAME}_id.rsa" -rqavz $DIR/build/ $REMOTE/
else
    bundle exec middleman deploy
fi;

date > ~/last_update_$NAME
rm -f $LOCKFILE ~/git_updated_${NAME}
