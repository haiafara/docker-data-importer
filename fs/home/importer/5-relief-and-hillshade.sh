# Resulting:
# - relief-* files are used by the mapnik style via basemap-relief.xml
# - hillshade-* files are used by the mapnik style via hillshade.xml
#
# For more information:
# https://github.com/der-stefan/OpenTopoMap/blob/master/mapnik/HOWTO_DEM.md

RELIEF_DIR=/mnt/data/relief
HILLSHADE_DIR=/mnt/data/hillshade

if [ ! -f "/mnt/data/hgt/raw.tif" ]; then
  echo "Merging SRTM3 files into raw.tif"
  gdal_merge.py -n 32767 -co BIGTIFF=YES -co TILED=YES -co COMPRESS=LZW -co PREDICTOR=2 -o /mnt/data/hgt/raw.tif /mnt/data/hgt/SRTM3v3.0/*.tif
fi

# create warped tifs for 5000, 1000, 500 and 30 meters
for res in 5000 1000 500 30
do
  if [ ! -f "warp-$res.tif" ]; then
    echo "Warping raw.tif into warp-$res.tif"
    gdalwarp -co BIGTIFF=YES -co TILED=YES -co COMPRESS=LZW -co PREDICTOR=2 -t_srs "+proj=merc +ellps=sphere +R=6378137 +a=6378137 +units=m" -r bilinear -tr $res $res /mnt/data/hgt/raw.tif warp-$res.tif
  fi
done

echo "Creating color relief for zoom factors 1-4"
gdaldem color-relief -co COMPRESS=LZW -co PREDICTOR=2 -alpha warp-5000.tif /home/importer/misc/relief_color.txt $RELIEF_DIR/relief-5000.tif
echo "Creating color relief for zoom factors 5-8"
gdaldem color-relief -co COMPRESS=LZW -co PREDICTOR=2 -alpha warp-500.tif /home/importer/misc/relief_color.txt $RELIEF_DIR/relief-500.tif

echo "Creating hillshade for the 5000 meters resolution"
gdaldem hillshade -z 7 -compute_edges -co COMPRESS=JPEG warp-5000.tif $HILLSHADE_DIR/hillshade-5000.tif
echo "Creating hillshade for the 1000 meters resolution"
gdaldem hillshade -z 7 -compute_edges -co BIGTIFF=YES -co COMPRESS=JPEG -co TILED=YES warp-1000.tif $HILLSHADE_DIR/hillshade-1000.tif
echo "Creating hillshade for the 500 meters resolution"
gdaldem hillshade -z 5 -compute_edges -co BIGTIFF=YES -co COMPRESS=JPEG -co TILED=YES warp-500.tif $HILLSHADE_DIR/hillshade-500.tif

if [ ! -f "$HILLSHADE_DIR/hillshade-30.tif" ]; then
  echo "Creating hillshade for the 30 meters resolution"
  gdaldem hillshade -z 2 -compute_edges -co BIGTIFF=YES -co COMPRESS=LZW -co PREDICTOR=2 warp-30.tif hillshade-30-temp.tif
  echo "Compressing to JPEG"
  gdal_translate -co BIGTIFF=yes -co COMPRESS=JPEG -co TILED=yes hillshade-30-temp.tif $HILLSHADE_DIR/hillshade-30.tif
fi

echo "Cleaning up"
for res in 5000 1000 500 30
do
  rm warp-$res.tif
done
rm hillshade-30-temp.tif
