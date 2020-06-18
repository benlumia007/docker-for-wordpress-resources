#!/usr/bin/env bash

if [[ ! -d "/srv/www/dashboard/public_html/phpmyadmin" ]]; then
    noroot mkdir -p "/srv/www/dashboard/public_html/phpmyadmin"
    cd "/srv/www/dashboard/public_html/phpmyadmin"
    noroot wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.zip -O "phpmyadmin.zip"
    noroot unzip "phpmyadmin.zip"
fi
