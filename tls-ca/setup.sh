#!/usr/bin/env bash

config=${PWD}/.global/docker-custom.yml

echo ${config}

get_sites() {
    local value=`cat ${config} | shyaml keys sites 2> /dev/null`
    echo ${value:-$@}
}

if [[ ! -d "/srv/certificates/ca" ]]; then
    mkdir -p "/srv/certificates/ca"
    openssl genrsa -out "/srv/certificates/ca/ca.key" 4096 &> /dev/null
    openssl req -x509 -new -nodes -key "/srv/certificates/ca/ca.key" -sha256 -days 365 -out "/srv/certificates/ca/ca.crt" -subj "/CN=Docker for WordPress" &> /dev/null
fi

if [[ -f "/srv/certificates/dashboard/dashboard.crt" ]]; then
    mkdir -p "/srv/certificates/dashboard"
    cp "/app/config/templates/certs.ext" "/srv/certificates/dashboard/dashboard.ext"
    sed -i -e "s/{{DOMAIN}}/dashboard/g" "/srv/certificates/dashboard/dashboard.ext"

    openssl genrsa -out "/srv/certificates/dashboard/dashboard.key" 4096 &> /dev/null
    openssl req -new -key "/srv/certificates/dashboard/dashboard.key" -out "/srv/certificates/dashboard/dashboard.csr" -subj "/CN=*.dashboard.test" &> /dev/null
    openssl x509 -req -in "/srv/certificates/dashboard/dashboard.csr" -CA "/srv/certificates/ca/ca.crt" -CAkey "/srv/certificates/ca/ca.key" -CAcreateserial -out "/srv/certificates/dashboard/dashboard.crt" -days 365 -sha256 -extfile "/srv/certificates/dashboard/dashboard.ext" &> /dev/null
fi

domains=`get_sites`

for domain in ${domains//- /$'\n'}; do
    provision=`cat ${config} | shyaml get-value sites.provision`

    if [[ "True" == ${provision} ]]; then
        if [[ ! -f "certificates/${domain}/${domain}.crt" ]]; then
            mkdir -p "certificates/${domain}"
            cp "config/certs/domain.ext" "certificates/${domain}/${domain}.ext"
            sed -i -e "s/{{DOMAIN}}/${domain}/g" "certificates/${domain}/${domain}.ext"
            rm -rf "certificates/${domain}/${domain}.ext-e"

            openssl genrsa -out "certificates/${domain}/${domain}.key" 4096 &> /dev/null
            openssl req -new -key "certificates/${domain}/${domain}.key" -out "certificates/${domain}/${domain}.csr" -subj "/CN=*.${domain}.test" &> /dev/null
            openssl x509 -req -in "certificates/${domain}/${domain}.csr" -CA "certificates/ca/ca.crt" -CAkey "certificates/ca/ca.key" -CAcreateserial -out "certificates/${domain}/${domain}.crt" -days 365 -sha256 -extfile "certificates/${domain}/${domain}.ext" &> /dev/null
        fi
    fi
done
