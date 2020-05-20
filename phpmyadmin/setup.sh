#!/usr/bin/env bash

if [[ ! -d "sites/dashboard/public_html/phpmyadmin" ]]; then
    mkdir -p "sites/dashboard/public_html/phpmyadmin"
    echo "extracting phpMyAdmin-5.0.1-all-languages"
    wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.zip -O "sites/dashboard/public_html/phpmyadmin/phpmyadmin.zip"
    unzip "sites/dashboard/public_html/phpmyadmin/phpmyadmin.zip"
    mv phpMyAdmin-5.0.2-all-languages/* "sites/dashboard/public_html/phpmyadmin"
    rm -rf phpMyAdmin-5.0.2-all-languages
    rm "sites/dashboard/public_html/phpmyadmin/phpmyadmin.zip"
    cp "config/phpmyadmin/config.inc.php" "sites/dashboard/public_html/phpmyadmin"
fi
