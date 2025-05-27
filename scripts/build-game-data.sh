#!/bin/bash

set -e

mkdir -p /var/cache/rtcw-server/gamefiles/download
mkdir -p /var/cache/rtcw-server/gamefiles/deb

for f in /var/cache/rtcw-server/gamefiles/deb/*.deb; do
  if [ -e "$f" ]; then
    echo "Game data package exists. Remove deb files and restart container to force rebuild."
  else
    echo "Game data package does not exist, building."
    /usr/games/game-data-packager rtcw -p rtcw-en-data --no-search --no-compress -n --download -d /var/cache/rtcw-server/gamefiles/deb --save-downloads /var/cache/rtcw-server/gamefiles/download /var/cache/rtcw-server/gamefiles/
  fi
done

echo "Installing game data package."
ls -t /var/cache/rtcw-server/gamefiles/deb/*deb | head -n1 | DEBIAN_FRONTEND=noninteractive xargs -n1 -t apt-get install

