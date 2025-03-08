# build and run dupeGuru in a Docker container
# two volumes are declared: /storage and /trash
# /storage will be used to hold folders you wish to compare (you can mount subdirectories)
# /trash is used by dupeGuru for direct file deletion (if enabled)

# Use the jlesage GUI base image (Alpine‑based with VNC/noVNC support)
FROM jlesage/baseimage-gui:alpine-3.20-v4.7.1

# Build arguments for dupeGuru (adjust version as needed)
ARG DUPEGURU_VERSION=4.3.1
ARG DUPEGURU_URL=https://github.com/arsenetar/dupeguru/archive/${DUPEGURU_VERSION}.tar.gz

# Set working directory
WORKDIR /tmp

# Install required packages for running and building dupeGuru
RUN add-pkg \
      py3-qt5 \
      py3-distro \
      py3-mutagen \
      py3-polib \
      py3-semantic-version \
      py3-send2trash \
      py3-xxhash \
      adwaita-qt \
      font-croscore

# Install build dependencies, download, patch, and compile dupeGuru
RUN add-pkg --virtual build-dependencies \
      build-base \
      python3-dev \
      py3-sphinx \
      py3-pip \
      gettext \
      curl && \
    mkdir dupeguru && \
    curl -L -# ${DUPEGURU_URL} | tar xz --strip 1 -C dupeguru && \
    sed-patch 's/import imp/from importlib import import_module/' dupeguru/hscommon/pygettext.py && \
    cd dupeguru && \
    make PREFIX=/usr/ NO_VENV=1 install && \
    cd .. && \
    del-pkg build-dependencies && \
    rm -rf /tmp/* /tmp/.[!.]*

# copy rootfs files to the container for setup
COPY rootfs/ /

# Install application icon (optional)
RUN APP_ICON_URL=https://github.com/jlesage/docker-templates/raw/master/jlesage/images/dupeguru-icon.png && \
    install_app_icon.sh "$APP_ICON_URL"

# Set runtime environment variables (for the GUI)
RUN set-cont-env APP_NAME "dupeGuru" && \
    set-cont-env APP_VERSION "$DUPEGURU_VERSION" && \
    set-cont-env TRASH_DIR "/trash" && \
    true

# Declare two mountable volumes
# /storage will be used to hold folders you wish to compare (you can mount subdirectories)
# /trash is used by dupeGuru for direct file deletion (if enabled)
VOLUME ["/storage"]
VOLUME ["/trash"]

# (Optional) Label your image
LABEL org.label-schema.name="dupeguru" \
      org.label-schema.description="Docker container for dupeGuru" \
      org.label-schema.version="$DUPEGURU_VERSION" \
      org.label-schema.vcs-url="https://github.com/arsenetar/dupeguru" \
      org.label-schema.schema-version="1.0"

# Start dupeGuru when the container starts
# CMD ["/usr/bin/dupeguru"]
CMD ["/init"]
