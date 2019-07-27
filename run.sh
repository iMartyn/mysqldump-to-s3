#!/bin/bash

set -e
set -o pipefail

if [ "${AWS_BUCKET}" = "**None**" ]; then
  echo "You need to set the AWS_BUCKET environment variable."
  exit 1
fi

if [ "${PREFIX}" = "**None**" ]; then
  echo "You need to set the PREFIX environment variable."
  exit 1
fi

if [ ! -z "${AWS_ENDPOINT}" ]; then
  AWS_OPTIONS="--endpoint=${AWS_ENDPOINT}"
fi

if [ -z "${MYSQL_USER}" ]; then
  echo "You need to set the MYSQL_USER environment variable."
  exit 1
fi

if [ -z "${MYSQL_PASSWORD}" ]; then
  echo "You need to set the MYSQL_PASSWORD environment variable."
  exit 1
fi

if [ -z "${MYSQL_HOST}" ]; then
  echo "You need to set the MYSQL_HOST environment variable or link to a container named MYSQL."
  exit 1
fi

if [ -z "${DATE_FORMAT}" ]; then
  DATE_FORMAT="%Y/%m/%d"
fi

MYSQL_HOST_OPTS="-h $MYSQL_HOST --port $MYSQL_PORT -u $MYSQL_USER -p$MYSQL_PASSWORD"

echo "Starting dump of database(s) from ${MYSQL_HOST}..."

if [ "${MYSQLDUMP_DATABASES}" == "**All**" ]; then
  MYSQLDUMP_DATABASES="--all-databases"
fi

if [ "${MYSQLDUMP_TABLES}" == "**All**" ]; then
  MYSQLDUMP_TABLES=
fi

mysqldump $MYSQL_HOST_OPTS $MYSQLDUMP_OPTIONS $MYSQLDUMP_DATABASES $MYSQLDUMP_TABLES | gzip | aws ${AWS_OPTIONS} s3 cp - s3://$AWS_BUCKET/$PREFIX/$(date +"$DATE_FORMAT").sql.gz

echo "Done!"

exit 0
