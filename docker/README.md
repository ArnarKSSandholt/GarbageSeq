# Directory contents

This directory contains 4 Dockerfiles which should be built in the numbering order of the file names each using the previous number produced image as base image for the next image.

The commands used for in this project used image are:

```bash
docker build --build-arg PANDOC_TEMPLATES_VERSION=2.7.3 -t rocker/rstudio:3.6.1 .
docker build -t rocker/tidyverse .
docker build -t rocker-own-base .
docker build -t comp-gen .
```
Comment: it seems that the attempt to install the newest version of pandoc (2.7.3) didn't succeed.