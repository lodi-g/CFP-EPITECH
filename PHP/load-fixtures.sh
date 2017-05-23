#!/bin/sh

set -e

# Wait until the database is up
until mysql --host mariadb >/dev/null
do
    sleep 1
done

echo 'DROP DATABASE IF EXISTS foo; CREATE DATABASE foo;' | mysql --host mariadb
mysql --host mariadb foo < /database.sql

echo 'Fixtures loaded.'
