#!/bin/bash

set -e

echo Setting permissions on home and gamefiles directories
mkdir -p /var/cache/rtcw-server/home/server.iortcw/main
chown -Rv ${PUID}:${PGID} /var/cache/rtcw-server/home/
chown -Rv ${PUID}:${PGID} /var/cache/rtcw-server/gamefiles/

echo Adding user with UID ${PUID} and GID ${PGID}
groupadd -g ${PGID} iortcw && \
useradd -u ${PUID} -g iortcw -d /var/cache/rtcw-server/home -s /bin/bash iortcw 

/build-game-data.sh

if [ ! -f /var/cache/rtcw-server/home/server.iortcw/main/server.cfg ]; then
  echo No server config found, copying example config
  cp /example_server.cfg /var/cache/rtcw-server/home/server.iortcw/main/${SV_SERVERCONFIGFILE}
fi

RUNCMD="/usr/lib/rtcw/iowolfded +set com_homepath server.iortcw +set com_hunkmegs ${SV_HUNKMEGS} +set net_port ${SV_NETPORT} +set sv_punkbuster ${SV_PUNKBUSTER} +exec ${SV_SERVERCONFIGFILE}"

echo Launching server. Command line :
echo "${RUNCMD}"

su -l iortcw -c "cd && ${RUNCMD}"
