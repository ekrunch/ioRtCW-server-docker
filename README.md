# ioRtCW-server-docker documentation.

This is a container build / Docker Compose set up for the Return to Castle Wolfenstein dedicated server. The goal is to allow a user easily run an RtCW compatible game server. All that's needed is to provide the necessary RtCW data files that cannot be distributed and optionally a server config. A friend and I started this and I decided to publish the code so others could enjoy.

The container uses the Debian build of the "ioRtCW" server from [ioRtCW](https://github.com/iortcw/iortcw) project. More information on the base container image and packages used below in the [Supported Hardware Platforms](#supported-hardware-platforms) section.

## Prerequisites

You will need the original RtCW data files. I use the Steam version as it's already patched to the latest official version (1.41). If you're not using the Steam version, make sure the data files are patched up to 1.41! The official patches can be found in a compiled archive at the [ioRtCW Project](https://github.com/iortcw/iortcw). Look in the releases and you should see the "patch" zip files. Check out their README as well for more information.

## Installation

Create a directory on the server for the data files and another for the home directory.

```bash
# Create directory to hold RtCW gamefiles
mkdir -p /mnt/rtcw/gamefiles
# This will also need a "main" subdirectory under it
mkdir -p /mnt/rtcw/gamefiles/main

# Create directory to hold server config files / maps / etc.
# On first startup, a subdirectory named ``server.iortcw/main`` will be created under this mount and an example server.cfg will be placed in it.
mkdir -p /mnt/rtcw/home
```

Copy the RtCW data files (*.pk3 files and the "scripts" subdirectory) to the "gamefiles" mount location for the container. If you're using the Steam version of RtCW, the needed files will be located in the Steam library folder under ``steamapps\common\Return to Castle Wolfenstein\main``. The target folder is whatever your gamefiles directory is with the "main" directory intact. Here's an example.

The "main" directory underneath gamefiles should have the following files
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

## Configuring the server

Edit the server.cfg in the "\<home volume\>/server.iortcw/main" subdirectory. I highly recommend setting a password if you're opening the server to the Internet.

## Connecting to the server

Go into RtCW, switch to Multiplayer mode, drop down the console (`) and type "connect \<hostname\>:\<port\>". If you're using a server password, you'll need to use the "password" command before connecting.

## Password protecting the server

To create a password protected server, do the following -

In the server.cfg, do the following. 
- set sv_maxclients to the maximum number of clients you would like to have.
- set sv_privateclients to the same as sv_maxclients
- set sv_privatePassword to something
- restart the server
On the client, use the \password command in the console before they use \connect. If client are seeing "Server is Full", it's usually because they didn't enter the password correctly.

## Available environment variables

| Name | Description | Default |
| --- | --- | --- |
| TZ | Timezone | None |
| PUID | User ID | 27960 |
| PGID | Group ID | 27960 |
| SV_HUNKMEGS | Server Hunk in Megabytes - This can definitely be reduced. It's defaulted high to accomodate maps/mods that need it. | 128 |
| SV_PUNKBUSTER | Punkbuster Anti-Cheat | 0 (disabled) |
| SV_NETPORT | Network port (TCP and UDP) | 27960 |
| SV_SERVERCONFIGFILE | Server Configuration file, located in the home volume under ``server.iortcw/main`` | server.cfg |

## Required volumes

| Volume | Description |
| --- | --- |
| /var/cache/rtcw-server/gamefiles | Path to the official RtCW data files. They should be in a subfolder called "main" under this volume. See above the [Installation](#installation) section for the list of files that should be present. |
| /mnt/rtcw/home:/var/cache/rtcw-server/home | This will become the home directory for the iortcw user. The server.cfg and additional configuration files get placed here. A subdirectory will automatically be created on first launch called ``server.iortcw/main``. Server configuration goes in that directory. |

## Example compose.yaml

There is an example [compose.yaml](compose.yaml) available in this repo.

## Supported Hardware Platforms

The container is currently being built for amd64 and arm64. Those are the platforms that have been tested. Other platforms might work as well but there are no plans to add any more builds to this repository. The container is based on the official Debian Trixie slim container images and uses the rtcw-server, game-data-packager, and innoextract packages (and their dependencies). So if these packages will work on your platform of choice under Debian Trixie, you'll most likely be able to build this container.

More information on the packages used.

- [rtcw-server](https://packages.debian.org/trixie/rtcw-server)
- [game-data-packager](https://packages.debian.org/trixie/game-data-packager)
- [innoextract](https://packages.debian.org/trixie/innoextract)

## Podman Support

Never tried it. Couldn't tell you.