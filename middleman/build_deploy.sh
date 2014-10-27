#!/bin/bash
export PATH="/usr/local/bin:/srv/builder/bin:$PATH"
NAME=$1
REMOTE=$2
BRANCH=$3
EMAIL_ERROR=$4

if [ -f ~/lock_${NAME} ]; then
    exit 0
fi

date > ~/lock_${NAME}

DIR="/srv/builder/$NAME"
cd $DIR
git fetch -q

git pull --rebase
bundle install
bundle exec middleman build > ~/error_${NAME} 2>&1

if [ $? -ne 0 ]; then
    if [ -n "$MAIL" ]; then
        echo "Build failed for $NAME" | EMAIL=nobody@redhat.com mutt -s "Build failed for $NAME" $EMAIL_ERROR -a ~/error_${NAME}
    fi
    rm -f ~/lock_${NAME}
    exit 1
fi

rm -f ~/error_${NAME}
rsync -e "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i $HOME/.ssh/${NAME}_id.rsa" -rqavz $DIR/build/ $REMOTE/

date > ~/last_update_$NAME
rm -f ~/lock_${NAME}
