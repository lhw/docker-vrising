FROM cm2network/steamcmd:root as base-amd64
RUN apt-get update && \
    apt-get install -y \
      wine \
      wine64 \
      xserver-xorg \
      xvfb \
      expect

FROM --platform=arm64 sonroyaalmerol/steamcmd-arm64:root as base-arm64
COPY install.sh /install.sh
RUN /install.sh
RUN apt-get install -y \
      xserver-xorg \
      xvfb \
      expect

ARG TARGETARCH=
FROM base-${TARGETARCH}
ARG DEBIAN_FRONTEND="noninteractive"

LABEL maintainer="Tim Chaubet" \
  name="TrueOsiris/docker-vrising" \
  github="https://github.com/TrueOsiris/docker-vrising" \
  dockerhub="https://hub.docker.com/r/trueosiris/vrising" \
  org.opencontainers.image.authors="Tim Chaubet" \
  org.opencontainers.image.source="https://github.com/TrueOsiris/docker-vrising"

COPY init.sh /init.sh
COPY start.sh /start.sh

ENV PUID=1000 \
    PGID=1000 \
    TZ=UTC \
    ARM_COMPATIBILITY_MODE=false

VOLUME ["/mnt/vrising/server", "/mnt/vrising/persistentdata"]
CMD ["/init.sh"]
