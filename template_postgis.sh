#!/bin/bash
#
# Init script for template postgis
#
set -e

createdb -E UTF8 template_postgis;
psql -d postgres -c "UPDATE pg_database SET datistemplate='true' \
  WHERE datname='template_postgis'"
psql -d template_postgis -c "CREATE EXTENSION postgis;"
psql -d template_postgis -c "CREATE EXTENSION postgis_topology;"
psql -d template_postgis -c "GRANT ALL ON geometry_columns TO PUBLIC;"
psql -d template_postgis -c "GRANT ALL ON spatial_ref_sys TO PUBLIC;"
psql -d template_postgis -c "CREATE EXTENSION plpython3u;"
psql -d template_postgis -c "CREATE EXTENSION crankshaft VERSION 'dev';"
psql -d template_postgis -c "CREATE EXTENSION plproxy;"
