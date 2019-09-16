#!/usr/bin/env bash

config="config/docker-custom.yml"

get_sites() {
    local value=`cat ${config} | shyaml keys sites 2> /dev/null`
    echo ${value:-$@}
}

if [[ ! -d "certificates" ]]; then
    mkdir -p "certificates"
    openssl genrsa -out "certificates/ca.key" 4096 &> /dev/null
    openssl req -x509 -new -nodes -key "certificates/ca.key" -sha256 -days 365 -out "certificates/ca.crt" -subj "/CN=Docker for WordPress" &> /dev/null
fi

if [[ -f "certificates/ca.crt" ]]; then
    cp "config/certs/domain.ext" "certificates/dashboard.ext"
    sed -i -e "s/{{DOMAIN}}/dashboard/g" "certificates/dashboard.ext"
    rm -rf "certificates/dashboard.ext-e"

    openssl genrsa -out "certificates/dashboard.key" 4096 &> /dev/null
    openssl req -new -key "certificates/dashboard.key" -out "certificates/dashboard.csr" -subj "/CN=*.dashboard.test" &> /dev/null
    openssl x509 -req -in "certificates/dashboard.csr" -CA "certificates/ca.crt" -CAkey "certificates/ca.key" -CAcreateserial -out "certificates/dashboard.crt" -days 365 -sha256 -extfile "certificates/dashboard.ext" &> /dev/null
fi

for domain in `get_sites`; do
    if [[ -f "certificates/ca.crt" ]]; then
        cp "config/certs/domain.ext" "certificates/${domain}.ext"
        sed -i -e "s/{{DOMAIN}}/${domain}/g" "certificates/${domain}.ext"
        rm -rf "certificates/${domain}.ext-e"

        openssl genrsa -out "certificates/${domain}.key" 4096 &> /dev/null
        openssl req -new -key "certificates/${domain}.key" -out "certificates/${domain}.csr" -subj "/CN=*.${domain}.test" &> /dev/null
        openssl x509 -req -in "certificates/${domain}.csr" -CA "certificates/ca.crt" -CAkey "certificates/ca.key" -CAcreateserial -out "certificates/${domain}.crt" -days 365 -sha256 -extfile "certificates/${domain}.ext" &> /dev/null
    fi
done