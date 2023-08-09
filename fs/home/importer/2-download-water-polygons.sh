#!/bin/bash

# If you run this script many times and don't want to abuse the download server
# Move the two water polygon zips to one of your servers and update the link below
WATER_POLYGONS_MIRROR=https://osmdata.openstreetmap.de/download

# Get the generalized water polygons
mkdir -p /mnt/data/water-polygons
chmod -R a+r /mnt/data/water-polygons

cd /mnt/data/water-polygons

wget $WATER_POLYGONS_MIRROR/simplified-water-polygons-split-3857.zip
wget $WATER_POLYGONS_MIRROR/water-polygons-split-3857.zip

unzip simplified-water-polygons-split-3857.zip
unzip water-polygons-split-3857.zip

rm -rf *.zip
