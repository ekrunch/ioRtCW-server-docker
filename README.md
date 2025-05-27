# ioRtCW-server-docker

# **WARNING : Documentation is still a WIP**

This is a container build / compose set up for the Return to Castle Wolfenstein dedicated server. The build uses the "ioRtCW" server from [ioRtCW](https://github.com/iortcw/iortcw) project.

The goal is to allow a user to provide the necessary PK3 files that cannot be distributed, optionally a server config, an run a RtCW compatible game server. A friend and I started this and I decided to publish the code so others could enjoy.

### Instructions

### Available environment variables

| Name | Description | Default |
| --- | --- | --- |
| TZ | Timezone | None |
| PUID | User ID | 27960 |
| PGID | Group ID | 27960 |
| SV_HUNKMEGS | Server Hunk in Megabytes - This can definitely be reduced. It's defaulted high to accomodate maps/mods that need it. | 128 |
| SV_PUNKBUSTER | Punkbuster Anti-Cheat | 0 (disabled) |
| SV_NETPORT | Network port (TCP and UDP) | 27960 |
| SV_SERVERCONFIGFILE | Server Configuration file, located in the home volume under ``server.iortcw/main`` | server.cfg |

### Required volumes

| Volume | Description |
| --- | --- |
| /var/cache/rtcw-server/gamefiles | Path to the official RtCW data files. They should be in a subfolder called "main". All that is needed is the *.pk3 files from the official RtCW distribution |
| /mnt/rtcw/home:/var/cache/rtcw-server/home | This will become the home directory for the iortcw user. The server.cfg and additional configuration files get placed here. A subdirectory will automatically be created on first launch called ``server.iortcw/main``. Server configuration goes in that directory. |

### Example compose.yaml

There is an example [compose.yaml](compose.yaml) available in this repo.
