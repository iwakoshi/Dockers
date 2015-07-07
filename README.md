# Docker Image for Eclipse

## Usage

Create an eclipse.sh

```bash
#!/bin/bash

 docker run -it --rm --name eclipse -v ~/workspace/:/home/eclipse/workspace/ \
  -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  -d iwakoshi/eclipse
```
