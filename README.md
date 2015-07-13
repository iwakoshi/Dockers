# Docker Image for Eclipse

## Usage

Create an eclipse.sh like this.

```bash
#!/bin/bash

xhost +local:eclipse
docker run -ti --rm --name eclipse -v ~/workspace:/home/eclipse/workspace:rw \
 -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY \
 iwakoshi/eclipse --device /dev/snd
```

Make sure you have created the workspace folder in your home before running the docker.