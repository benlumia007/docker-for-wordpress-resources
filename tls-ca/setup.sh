#!/usr/bin/env bash

config="/srv/.global/custom.yml"

get_sites() {
    local value=`cat ${config} | shyaml keys sites 2> /dev/null`
    echo ${value:-$@}
}

if [[ ! -d "/srv/certificates/ca" ]]; then
    noroot mkdir -p "/srv/certificates/ca"
    noroot openssl genrsa -out "/srv/certificates/ca/ca.key" 4096 &> /dev/null
    noroot openssl req -x509 -new -nodes -key "/srv/certificates/ca/ca.key" -sha256 -days 365 -out "/srv/certificates/ca/ca.crt" -subj "/CN=Docker for WordPress" &> /dev/null
fi

if [[ ! -f "/srv/certificates/dashboard/dashboard.crt" ]]; then
    noroot mkdir -p "/srv/certificates/dashboard"
    noroot cp "/srv/config/apache2/certs.ext" "/srv/certificates/dashboard/dashboard.ext"
    noroot sed -i -e "s/{{DOMAIN}}/dashboard/g" "/srv/certificates/dashboard/dashboard.ext"

    noroot openssl genrsa -out "/srv/certificates/dashboard/dashboard.key" 4096 &> /dev/null
    noroot openssl req -new -key "/srv/certificates/dashboard/dashboard.key" -out "/srv/certificates/dashboard/dashboard.csr" -subj "/CN=*.dashboard.test" &> /dev/null
    noroot openssl x509 -req -in "/srv/certificates/dashboard/dashboard.csr" -CA "/srv/certificates/ca/ca.crt" -CAkey "/srv/certificates/ca/ca.key" -CAcreateserial -out "/srv/certificates/dashboard/dashboard.crt" -days 365 -sha256 -extfile "/srv/certificates/dashboard/dashboard.ext" &> /dev/null
fi

domains=`get_sites`

for domain in ${domains//- /$'\n'}; do
    provision=`cat ${config} | shyaml get-value sites.${domain}.provision`

    if [[ "True" == ${provision} ]]; then
        if [[ ! -f "/srv/certificates/${domain}/${domain}.crt" ]]; then
            noroot mkdir -p "/srv/certificates/${domain}"
            noroot cp "/srv/config/apache2/certs.ext" "/srv/certificates/${domain}/${domain}.ext"
            noroot sed -i -e "s/{{DOMAIN}}/${domain}/g" "/srv/certificates/${domain}/${domain}.ext"
            noroot rm -rf "/srv/certificates/${domain}/${domain}.ext-e"

            noroot openssl genrsa -out "/srv/certificates/${domain}/${domain}.key" 4096 &> /dev/null
            noroot openssl req -new -key "/srv/certificates/${domain}/${domain}.key" -out "/srv/certificates/${domain}/${domain}.csr" -subj "/CN=*.${domain}.test" &> /dev/null
            noroot openssl x509 -req -in "/srv/certificates/${domain}/${domain}.csr" -CA "/srv/certificates/ca/ca.crt" -CAkey "/srv/certificates/ca/ca.key" -CAcreateserial -out "/srv/certificates/${domain}/${domain}.crt" -days 365 -sha256 -extfile "/srv/certificates/${domain}/${domain}.ext" &> /dev/null
        fi
    fi
done
