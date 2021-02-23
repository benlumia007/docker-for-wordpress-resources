#!/usr/bin/env bash

if [[ ! -d "/srv/www/dashboard/public_html/phpmyadmin" ]]; then
    noroot mkdir -p "/srv/www/dashboard/public_html/phpmyadmin"
    cd "/srv/www/dashboard/public_html/phpmyadmin"
    noroot wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.zip -O "phpmyadmin.zip"
    noroot unzip "phpmyadmin.zip"
    noroot mv phpMyAdmin-5.0.4-all-languages/* "/srv/www/dashboard/public_html/phpmyadmin"
    noroot rm -rf phpMyAdmin-5.0.4-all-languages
    noroot rm "phpmyadmin.zip"
    noroot cp "/app/config/templates/config.inc.php" "/srv/www/dashboard/public_html/phpmyadmin"
    cd /app
fi

