---
author: Andreas Wachs
title: 'Kali Linux in Docker: XFCE Desktop over VNC/noVNC'
date: 2025-08-31
description: Run a full Kali Linux desktop in Docker and access it via VNC or a browser with noVNC.
tags: [ containers, kali, docker, tooling ]
---

This post describes a small project that packages a full Kali Linux desktop inside a Docker container and exposes the UI over VNC and noVNC. The target audience is technical readers who want a reproducible, disposable Kali environment for testing, demos, or tooling.

- **Repository**: [https://github.com/andreaswachs/kali-docker](https://github.com/andreaswachs/kali-docker)

## What the image provides

- A Kali Linux (rolling) base with a full desktop (default: XFCE).
- `tightvncserver` as the VNC server for the desktop session.
- `noVNC` to proxy the VNC session over HTTPS so the desktop is accessible from a browser.
- Build-time knobs: `KALI_DESKTOP` (desktop variant) and `KALI_METAPACKAGE` (package set) to create tailored images (`core`, `top10`, `large`, ...).

## Typical use cases

- Disposable testbeds: run GUI-only Kali tools without touching your host system.
- Demos and workshops: provision a graphical Kali instance quickly for teaching or presentations.
- Remote GUI tooling: run GUI applications in an isolated container and access them from anywhere via the browser.

## Quickstart

Pull a published image:

```
docker pull andreaswachs/kali-docker:latest-core
```

Run the container (example):

```
docker run --rm -it -p 9020:8080 -p 9021:5900 andreaswachs/kali-docker:latest-core
```

This starts noVNC on `https://localhost:9020/vnc.html` and a VNC server on `localhost:9021` (if `VNCEXPOSE` is enabled). Default environment variables:

- `VNCEXPOSE=0` — VNC bound to localhost inside the container
- `VNCPORT=5900` — VNC server port inside the container
- `VNCPWD=changeme` — default VNC password (change before exposing)
- `VNCDISPLAY=1920x1080` — display resolution
- `VNCDEPTH=16` — color depth
- `NOVNCPORT=8080` — internal port noVNC listens on

The included `Makefile` has a `make run` target that creates a Docker volume and mounts it to `/home`, making the home directory persistent across runs. Override the volume name with `PERSISTENCE`.

## Building a custom image

To customize the desktop or package set, build from source:

```
git clone https://github.com/andreaswachs/kali-docker
cd kali-docker
docker build -t my-local-kali-docker --build-arg KALI_DESKTOP=xfce KALI_METAPACKAGE=large .
docker run --rm -it -p 9020:8080 -p 9021:5900 my-local-kali-docker
```

The `Dockerfile` installs `kali-desktop-${KALI_DESKTOP}` and, depending on `KALI_METAPACKAGE`, either `kali-linux-${KALI_METAPACKAGE}` or `kali-tools-top10`.

## Security and caveats

- Intended for testing and demos only — avoid running on production hosts.
- The container will generate a self-signed certificate for noVNC if none is provided. Mount your own certificate and key with:

```
-v /your/path/to/cert.pem:/etc/ssl/certs/novnc_cert.pem \
-v /your/path/to/key.pem:/etc/ssl/certs/novnc_key.pem
```

- Default VNC password is `changeme`. Always set `VNCPWD` to a secure value before exposing ports.

## Implementation notes

- Base image: `kalilinux/kali-rolling:latest`.
- Packages installed: `tightvncserver`, `dbus`, `dbus-x11`, and `novnc`.
- `entrypoint.sh` sets the VNC password, starts the VNC server (optionally hostname-restricted), and launches noVNC using the combined certificate.

## Links

- Source: [https://github.com/andreaswachs/kali-docker](https://github.com/andreaswachs/kali-docker)

If you'd like, I can add screenshots, a short demo GIF, or a step-by-step customization guide.