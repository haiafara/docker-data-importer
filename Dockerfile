FROM debian:bookworm-slim

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  build-essential \
  ca-certificates \
  gdal-bin \
  libgdal-dev \
  git=1:2.39.2-1.1 \
  osm2pgsql \
  postgresql-client-15=15.3-0+deb12u1 \
  python3 \
  python3-pip \
  python3-venv \
  python3-gdal \
  python3-lxml \
  unzip \
  wget \
  mc && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

ENV PGHOST=127.0.0.1
ENV PGUSER=postgres
ENV PGDATABASE=postgres

# create a data folder (which will be mounted as a volume)
RUN mkdir -p /mnt/data

# create a home for the app user
RUN mkdir -p /home/importer
WORKDIR /home/importer

RUN python3 -m venv --system-site-packages /opt/venv

RUN . /opt/venv/bin/activate && pip install git+https://github.com/haiafara/pyhgtmap.git@fix-earthexplorer-login-throttle

COPY fs /
RUN chmod 0600 /root/.pgpass
