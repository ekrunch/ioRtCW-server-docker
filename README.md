# ioRtCW-server-docker

This is a container build / compose set up for the Return to Castle Wolfenstein dedicated server. The build uses the "ioRtCW" server from [ioRtCW](https://github.com/iortcw/iortcw) project.

### Available environment variables

- TZ
- PUID
- PGID
- SV_HUNKMEGS
- SV_PUNKBUSTER
- SV_NETPORT
- SV_SERVERCONFIGFILE

*** Required volumes

``/var/cache/rtcw-server/gamefiles``
**Path to the official RtCW data files. They should be in a subfolder called "main". All that is needed is the *.pk3 files from the official RtCW distribution**

``/mnt/rtcw/home:/var/cache/rtcw-server/home``
**This will become the home directory for the iortcw user. The server.cfg and additional configuration files get placed here.**


- /var/cache/rtcw-server/gamefiles
- /var/cache/rtcw-server/home

*** Example compose.yaml

There is a compose.yaml in this repo
