#!/usr/bin/env bash

if [[ ! -d "sites/dashboard/public_html/phpmyadmin" ]]; then
    mkdir -p "sites/dashboard/public_html/phpmyadmin"
    echo "extracting phpMyAdmin-4.8.5-all-languages"
    wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.zip -O "sites/dashboard/public_html/phpmyadmin/phpmyadmin.zip"
    unzip "sites/dashboard/public_html/phpmyadmin/phpmyadmin.zip"
    mv phpMyAdmin-4.9.0.1-all-languages/* "sites/dashboard/public_html/phpmyadmin"
    rm -rf phpMyAdmin-4.9.0.1-all-languages
    rm "sites/dashboard/public_html/phpmyadmin/phpmyadmin.zip"
fi
