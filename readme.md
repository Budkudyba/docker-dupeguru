# Docker Image of dupeguru
### Takes a base image with VNC or noVNC and runs dupeguru in a container.
The Dockerfile is based on:
https://github.com/jlesage/docker-baseimage-gui

The App is based on dupeguru:
https://github.com/arsenetar/dupeguru

---

typical usage:

* `docker compose build`
* `docker compose up`
* Navigate browser to `http://[ip]:5800`
  * eg. http://localhost:5800

### Notes:
* the Dockerfile pulls the latest dupeguru from the git repo
* the base image is a `jlesage/baseimage-gui:alpine-3.20-v4.7.1`
