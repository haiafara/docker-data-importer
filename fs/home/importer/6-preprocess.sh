#!/bin/bash

# For more information:
# https://github.com/der-stefan/OpenTopoMap/blob/master/mapnik/HOWTO_Preprocessing

cd tools

echo "Compiling tools"
cc -o saddledirection saddledirection.c -lm -lgdal
cc -Wall -o isolation isolation.c -lgdal -lm -O2

echo "Importing arealabel.sql"
psql gis < arealabel.sql

echo "Starting update_lowzoom.sh"
./update_lowzoom.sh

echo "Starting update_saddles.sh"
./update_saddles.sh

echo "Starting update_isolations.sh"
./update_isolations.sh

echo "Importing stationdirection.sql"
psql gis < stationdirection.sql

echo "Importing viewpointdirection.sql"
psql gis < viewpointdirection.sql

echo "Importing pitchicon.sql"
psql gis < pitchicon.sql
