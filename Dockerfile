# EasyToPaste CLI in a container — one-time, client-encrypted secret links from
# any pipeline that can run an image but cannot install a global npm package.
#
# The image installs the PUBLISHED package rather than copying source into it.
# That keeps one artifact of record (the npm tarball) and makes the image a
# distribution channel rather than a second implementation that can drift.
FROM node:20-alpine

ARG ETP_VERSION=0.1.1
LABEL org.opencontainers.image.title="easytopaste"
LABEL org.opencontainers.image.description="Share a password or API key through a one-time, client-encrypted link"
LABEL org.opencontainers.image.source="https://github.com/Nemet360/easytopaste-docker"
LABEL org.opencontainers.image.url="https://easytopaste.com/?utm_source=ghcr&utm_medium=container&utm_campaign=launch-2026-11"
LABEL org.opencontainers.image.licenses="SEE LICENSE IN LICENSE.md"

RUN npm install -g "easytopaste@${ETP_VERSION}" \
    && npm cache clean --force

# How a container install is distinguishable on the service side. A utm tag
# measures a click on a link, and nobody who runs this in a pipeline loads a
# page, so the request header is the only place the channel can appear. The
# field reaches the service from CLI 0.1.2 onward; 0.1.1 ignores it.
ENV EASYTOPASTE_CHANNEL=docker

# Never root: this handles secrets, and the image needs no write access to
# anything outside the work directory.
USER node
WORKDIR /work

ENTRYPOINT ["easytopaste"]
CMD ["--help"]
