#!/bin/bash

export PATH="/usr/local/bin:$HOME/bin:$PATH"
CONFIG=$1
source $CONFIG

if [ -f ~/lock_${NAME} ]; then
    exit 0
fi

date > ~/lock_${NAME}

DIR="$HOME/$NAME"
cd $DIR
git fetch -q

git pull --rebase
eval $BUILD_COMMAND >  ~/error_${NAME} 2>&1


if [ $? -ne 0 ]; then
    if [ -n "$MAIL" ]; then
        echo "Build failed for $NAME" | EMAIL=nobody@gluster.org mutt -s "Build failed for $NAME" $EMAIL_ERROR -a ~/error_${NAME}
    fi
    rm -f ~/lock_${NAME}
    exit 1
fi

rm -f ~/error_${NAME}
rsync -e "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i $HOME/.ssh/${NAME}_id.rsa" -rqavz $DIR/$RESULT_DIR $REMOTE/

date > ~/last_update_$NAME
rm -f ~/lock_${NAME}
