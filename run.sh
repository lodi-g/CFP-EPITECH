#!/bin/bash

set -e

function down() {
    docker-compose down
}

function build() {
    docker-compose build >/dev/null
}

function js() {
    down
    build
    docker-compose up -d js
    docker-compose run --no-deps inject bash js.sh
    down
}

function php() {
    down
    build
    docker-compose up -d php
    docker-compose run --no-deps inject bash php.sh
    down
}

function both() {
    down
    build
    docker-compose up -d php js
    docker-compose run --no-deps inject
    down
}

case $1 in
  j|js|JS|mongo|mongodb ) js;;
  p|php|PHP|sql|SQL|mysql ) php;;
  *) both;;
esac
