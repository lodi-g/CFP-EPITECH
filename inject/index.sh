#!/bin/bash

set -e

echo '----------------- MongoDB injection -----------------'
bash js.sh

echo
echo '----------------- SQL injection -----------------'
bash php.sh
