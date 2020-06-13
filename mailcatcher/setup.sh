#!/usr/bin/env bash

if [[ ! -f "/usr/local/bin/mailcatcher" ]]; then
    sudo apt update -y
    sudo apt install libsqlite3-dev ruby-dev -y
    sudo gem install mailcatcher
fi