#!/usr/bin/env bash

if [[ ! -d "/srv/www/dashboard/public_html/phpmyadmin" ]]; then
    mkdir -p "/srv/www/dashboard/public_html/phpmyadmin"
    echo "extracting phpMyAdmin-5.0.1-all-languages"
    wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.zip -O "/srv/www/dashboard/public_html/phpmyadmin/phpmyadmin.zip"
    unzip "/srv/www/dashboard/public_html/phpmyadmin/phpmyadmin.zip"
    mv phpMyAdmin-5.0.2-all-languages/* "/srv/www/dashboard/public_html/phpmyadmin"
    rm -rf phpMyAdmin-5.0.2-all-languages
    rm "/srv/www/dashboard/public_html/phpmyadmin/phpmyadmin.zip"
    cp "/app/config/config.inc.php" "/srv/www/dashboard/public_html/phpmyadmin"
fi
