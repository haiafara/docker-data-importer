#!/bin/bash

createdb gis
psql -d gis -c "CREATE EXTENSION postgis;"
