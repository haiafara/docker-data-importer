LEFT=20.2201924985
BOTTOM=42.5
RIGHT=29.62654341
TOP=49.5

. /opt/venv/bin/activate

pyhgtmap \
  -o contour \
  --step=10 \
  -0 \
  --pbf \
  --hgtdir=/mnt/data/hgt \
  -a $LEFT:$BOTTOM:$RIGHT:$TOP \
  --earthexplorer-user=$EE_USER \
  --earthexplorer-password=$EE_PASSWORD

mv contour_*.pbf /mnt/data/contour
