#!/usr/bin/env bash

if [[ ! -f "/usr/local/bin/mailhog" ]]; then
    sudo curl --silent -L -o /usr/local/bin/mailhog https://github.com/mailhog/MailHog/releases/download/v1.0.0/MailHog_linux_amd64
    sudo chmod +x /usr/local/bin/mailhog
    sudo curl --silent -L -o /usr/local/bin/mhsendmail https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64
    sudo chmod +x /usr/local/bin/mhsendmail
fi