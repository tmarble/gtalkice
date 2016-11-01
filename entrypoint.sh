#!/bin/sh
# entrypoint.sh

set -x
echo "YOU SAID $@"
# NOTE test will work for bash AND dash
# if test "X$@" = "X"; then
if [ "X$@" = "X" ]; then
    cmd="iceweasel"
else
    cmd=$@
fi

USER=${DOCKER_USER:-browser}
USER_UID=${DOCKER_UID:-1000}
USER_GID=${DOCKER_GID:-100}

# create user, if needed
if getent passwd $USER > /dev/null; then
    echo "user exists: $USER"
else
    echo "creating user: $USER"
    # addgroup --gid $USER_GID $USER
    adduser --disabled-login --uid $USER_UID --gid $USER_GID --gecos 'Browser User' --home /tmp/$USER $USER
    if [ ! -d /home/$USER/.config ]; then
        mkdir -p /home/$USER/.config
    fi
    if [ ! -e /home/$USER/.mozilla ]; then
        ln -s .config/.mozilla /home/$USER/.mozilla
    fi
    chown -R $USER_UID.$USER_GID /home/$USER
    chmod 770 /home/$USER/.config
    mv /tmp/$USER/.[a-z]* /home/$USER/
    usermod --home /home/$USER $USER
    # addgroup $USER users
    addgroup $USER audio
    addgroup $USER video
fi

echo "DETAILS..."
ls -l /dev/video0
ls -l /tmp/.X11-unix
ls -ld /home/$USER/.config
ls -l /home/$USER/.config

echo "ENV..."
env

echo "GO..."

cd /home/$USER
if [ "$cmd" = "rootbash" ]; then
    exec /bin/bash
fi
export HOME=/home/$USER

exec sudo --preserve-env -u $USER $cmd
