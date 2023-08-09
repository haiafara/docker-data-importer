#!/bin/bash

# import contours data into db
dropdb --if-exists contours
createdb contours
psql -d contours -c 'CREATE EXTENSION postgis;'
# psql -d contours -c 'GRANT SELECT ON ALL TABLES IN SCHEMA public TO tirex;'
osm2pgsql \
  --slim \
  -d contours \
  -C 12000 \
  --number-processes 8 \
  --style /home/importer/styles/contours.style \
  /mnt/data/contour/contour_*.pbf
# psql -d contours -c 'GRANT SELECT ON ALL TABLES IN SCHEMA public TO tirex;'
