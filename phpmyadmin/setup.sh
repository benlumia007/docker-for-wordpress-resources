#!/usr/bin/env bash

if [[ ! -d "sites/dashboard/public_html/phpmyadmin" ]]; then
    mkdir -p "sites/dashboard/public_html/phpmyadmin"
    cd "sites/dashboard/public_html/phpmyadmin"
    echo "extracting phpMyAdmin-4.8.5-all-languages"
    wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.zip -O phpmyadmin.zip
    unzip phpmyadmin.zip -d "sites/dashboard/public_html/phpmyadmin"
    mv phpMyAdmin-4.9.0.1-all-languages/* "sites/dashboard/public_html/phpmyadmin"
    rm -rf phpMyAdmin-4.9.0.1-all-languages
    rm phpmyadmin.zip
fi
