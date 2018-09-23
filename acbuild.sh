#!/usr/bin/env bash
set -e

if [ "$EUID" -ne 0 ]; then
    echo "This script uses functionality which requires root privileges"
    exit 1
fi

acbuild --debug begin

trap "{ export EXT=$?; acbuild --debug end && exit $EXT; }" EXIT

acbuild --debug set-name mbuella/hello-world
acbuild --debug dep add quay.io/coreos/alpine-sh
acbuild --debug run -- apk update
acbuild --debug run -- apk add nginx
acbuild --debug mount add html /usr/share/nginx/html
acbuild --debug set-working-directory /usr/share/nginx/html
acbuild --debug set-exec -- /usr/sbin/nginx -g "daemon off;"
acbuild --debug write hello-world.aci

# Run this afterwards
#sudo rkt run --insecure-options=image ./hello-world.aci --volume html,kind=host,source=/home/mharz_buella/hello-world/html --net=host
