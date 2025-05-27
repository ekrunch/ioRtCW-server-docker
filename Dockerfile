# The versions in Bookworm are too old so trixie is required to make this work
FROM debian:trixie-slim

# Update apt-get cache and install packages
RUN sed -r -i '/^Components:/ s/main/main contrib/g' /etc/apt/sources.list.d/debian.sources && \
        apt-get update -y && \
        # Install rtcw package
        DEBIAN_FRONTEND=noninteractive apt-get install rtcw-server game-data-packager innoextract -y && \
        # Clean up
        rm -rf /var/lib/apt/lists/*

# Environment
ENV PUID=27960 \
    PGID=27960 \
    SV_HUNKMEGS=128 \
    SV_PUNKBUSTER=0 \
    SV_NETPORT=27960 \
    SV_SERVERCONFIGFILE=server.cfg

# Require the following mounts
VOLUME ["/var/cache/rtcw-server/gamefiles"]
VOLUME ["/var/cache/rtcw-server/home"]

# Copy build and entrypoint scripts into the container
COPY --chmod=0755 scripts/build-game-data.sh scripts/entrypoint.sh scripts/example_server.cfg /
COPY --chmod=0644 scripts/example_server.cfg /

# The entrypoint builds the data files package, if necessary, and starts the server
ENTRYPOINT ["/entrypoint.sh"]
