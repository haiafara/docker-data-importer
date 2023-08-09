#!/bin/bash

DATA_FILE=/mnt/data/pbf/romania-latest.osm.pbf

MEMORY=12000
CORES=8

if [ ! -f $DATA_FILE ]; then
  echo "No OSM data found. Please download a file and put it into $DATA_FILE"
  exit
fi

mkdir -p /mnt/db/flat-nodes

psql -d gis -c "CREATE TABLESPACE hdd LOCATION '/mnt/extras/tiles';"

osm2pgsql \
  -d gis \
  -U postgres \
  --slim \
  -C $MEMORY \
  --number-processes $CORES \
  --tablespace-slim-data hdd \
  --tablespace-slim-index hdd \
  --flat-nodes /mnt/db/flat-nodes/gis-flat-nodes.bin \
  --style /home/importer/styles/opentopomap.style \
  $DATA_FILE
