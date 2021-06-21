#!/usr/bin/env bash

if [[ ! -d "/srv/www/dashboard/public_html/phpmyadmin" ]]; then
    noroot mkdir -p "/srv/www/dashboard/public_html/phpmyadmin"
    cd "/srv/www/dashboard/public_html/phpmyadmin"
    noroot wget -q https://files.phpmyadmin.net/phpMyAdmin/5.1.0/phpMyAdmin-5.1.0-all-languages.zip -O "phpmyadmin.zip"
    noroot unzip -q "phpmyadmin.zip"
    noroot mv phpMyAdmin-5.1.0-all-languages/* "/srv/www/dashboard/public_html/phpmyadmin"
    noroot rm -rf phpMyAdmin-5.1.0-all-languages
    noroot rm "phpmyadmin.zip"
    noroot cp "/srv/config/phpmyadmin/config.inc.php" "/srv/www/dashboard/public_html/phpmyadmin"
    cd /app
fi
