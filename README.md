# ioRtCW-server-docker

# **WARNING : Documentation is still a WIP**

This is a container build / Docker Compose set up for the Return to Castle Wolfenstein dedicated server. The build uses the "ioRtCW" server from [ioRtCW](https://github.com/iortcw/iortcw) project.

The goal is to allow a user to provide the necessary PK3 files that cannot be distributed, optionally a server config, an run a RtCW compatible game server. A friend and I started this and I decided to publish the code so others could enjoy.

### Prerequisites

You will need the original RtCW data files. I use the Steam version as it's already patched to the latest official version (1.41). If you're not using the Steam version, make sure the data files are patched up to 1.41! The official patches can be found in a compiled archive at the [ioRtCW Project](https://github.com/iortcw/iortcw). Look in the releases and you should see the "patch" zip files. Check out their README as well for more information.

### Installation

Create a directory on the server for the data files and another for the home directory.

```
# Create directory to hold RtCW gamefiles
mkdir -p /mnt/rtcw/gamefiles
# This will also need a "main" subdirectory under it
mkdir -p /mnt/rtcw/gamefiles/main

# Create directory to hold server config files / maps / etc.
# On first startup, a folder named ``server.iortcw/main`` will be created and an example server.cfg will be placed in it.
mkdir -p /mnt/rtcw/home
```

Copy the *.pk3 files and the "scripts" subdirectory. If you're using the Steam version, they'll be located in the Steam library folder under ``steamapps\common\Return to Castle Wolfenstein\main``. The target folder is whatever your gamefiles directory is with the "main" directory intact. Here's an example.

The destination folder should have the following files
```
mp_bin.pk3
mp_pak0.pk3
mp_pak1.pk3
mp_pak2.pk3
mp_pak3.pk3
mp_pak4.pk3
mp_pak5.pk3
mp_pakmaps0.pk3
mp_pakmaps1.pk3
mp_pakmaps2.pk3
mp_pakmaps3.pk3
mp_pakmaps4.pk3
mp_pakmaps5.pk3
mp_pakmaps6.pk3
pak0.pk3
scripts/translation.cfg
sp_pak1.pk3
sp_pak2.pk3
sp_pak3.pk3
sp_pak4.pk3
```

Edit the [compose.yaml](compose.yaml) and adjust paths, ports, network names, etc to your liking.

That's it. You can start the container now (docker compose up -d) and it will automatically package up the pk3 files and put them in the right place. Note that it only needs to package the datafiles once and will not redo them unless it needs to. You'll notice the creation of a subdirectory called "deb" with an rtcw-en-data*.deb in it as well as a subdirectory called "download" with the ioRtCW archive in it. If you want to force a rebuild, remove the "deb" and "download" directories and restart the container.

### Configuring the server

Edit the server.cfg in the "\<home volume\>/server.iortcw/main" subdirectory. I highly recommend setting a password if you're opening the server to the Internet. There are lots of docs out there on how to configure th server and options available. The provided sample config 

### Connecting to the server

Go into RtCW, switch to Multiplayer mode, drop down the console (`) and type "connect \<hostname\>:\<port\>".

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

### Podman Support

Never tried it. Couldn't tell you.