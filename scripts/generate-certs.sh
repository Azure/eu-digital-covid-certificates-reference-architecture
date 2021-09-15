#!/bin/bash

set -euo pipefail

ABSOLUTE_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_PROJ_PATH="${ABSOLUTE_PATH}/.."
STORE_PASS="dgcg-p4ssw0rd"

echo "${ROOT_PROJ_PATH}/certs"
test -d "${ROOT_PROJ_PATH}/certs" && { echo "Certs already exist"; exit 0; }
echo "Creating certs directory"

mkdir "${ROOT_PROJ_PATH}/certs"
pushd "${ROOT_PROJ_PATH}/certs"

echo "Generate the DGC Gateway Trustanchor"
openssl req -x509 -newkey rsa:4096 -keyout key_ta.pem -out cert_ta.pem -days 365 -nodes -subj "/C=EU/CN=EU DGC TrustAnchor"

echo "Create a P12 of the DGC Gateway Trustanchor"
openssl pkcs12 -export -in cert_ta.pem -inkey key_ta.pem -name dgcg_trust_anchor -out ta.p12 -password "pass:$STORE_PASS"

echo "Download LetsEncrypt Roots"
rm -f isrgrootx1.pem isrg-root-x2.pem
wget https://letsencrypt.org/certs/isrgrootx1.pem
wget https://letsencrypt.org/certs/isrg-root-x2.pem

echo "Create the TLS Trust Store P12"
keytool -importcert -noprompt -alias dgcg_trust_anchor -file cert_ta.pem -keystore tls_trust_store.p12 -storepass $STORE_PASS -storetype PKCS12
keytool -importcert -noprompt -alias letsencrypt_x1 -file isrgrootx1.pem -keystore tls_trust_store.p12 -storepass $STORE_PASS -storetype PKCS12
keytool -importcert -noprompt -alias letsencrypt_x2 -file isrg-root-x2.pem -keystore tls_trust_store.p12 -storepass $STORE_PASS -storetype PKCS12

# Create empty trusted-parties.json to be filled later
echo '[]' > trusted-parties.json

# Function for generating a countries certs
generate_country() {
    local country=$1

    echo "Generating $country Auth Cert/Key"
    openssl req \
       -newkey rsa:2048 -nodes -keyout ${country}_key_auth.pem \
       -out ${country}_cert_auth.csr \
       -subj "/C=${country}/CN=${country} Auth Cert"

    openssl x509 -req -in ${country}_cert_auth.csr \
        -CA cert_ta.pem -CAkey key_ta.pem -CAcreateserial \
        -out ${country}_cert_auth.pem -days 365 -sha256

    echo "Create a P12 of the $country Auth Key"
    openssl pkcs12 -export -in ${country}_cert_auth.pem -inkey ${country}_key_auth.pem -name auth -out ${country}_auth.p12 -password "pass:$STORE_PASS"

    echo "Generating $country CSCA Cert/Key"
    openssl req \
       -newkey rsa:2048 -nodes -keyout ${country}_key_csca.pem \
       -out ${country}_cert_csca.csr \
       -subj "/C=${country}/CN=${country} CSCA Cert"

    openssl x509 -req -in ${country}_cert_csca.csr \
        -CA cert_ta.pem -CAkey key_ta.pem -CAcreateserial \
        -out ${country}_cert_csca.pem -days 365 -sha256

    echo "Create a P12 of the $country CSCA Key"
    openssl pkcs12 -export -in ${country}_cert_csca.pem -inkey ${country}_key_csca.pem -name csca -out ${country}_csca.p12 -password "pass:$STORE_PASS"

    echo "Generating $country DSC Cert/Key"
    openssl req \
       -newkey rsa:2048 -nodes -keyout ${country}_key_dsc.pem \
       -out ${country}_cert_dsc.csr \
       -subj "/C=${country}/CN=${country} DSC Cert"

    # Note, this is signed by the Countries CSCA.
    openssl x509 -req -in ${country}_cert_dsc.csr \
        -CA ${country}_cert_csca.pem -CAkey ${country}_key_csca.pem -CAcreateserial \
        -out ${country}_cert_dsc.pem -days 365 -sha256

    echo "Create a P12 of the $country DSC Key"
    openssl pkcs12 -export -in ${country}_cert_dsc.pem -inkey ${country}_key_dsc.pem -name dsc -out ${country}_dsc.p12 -password "pass:$STORE_PASS"

    echo "Generating $country Upload Cert/Key"
    openssl req \
       -newkey rsa:2048 -nodes -keyout ${country}_key_upload.pem \
       -out ${country}_cert_upload.csr \
       -subj "/C=${country}/CN=${country} Upload Cert"

    openssl x509 -req -in ${country}_cert_upload.csr \
        -CA cert_ta.pem -CAkey key_ta.pem -CAcreateserial \
        -out ${country}_cert_upload.pem -days 365 -sha256

    echo "Create a P12 of the $country Upload Key"
    openssl pkcs12 -export -in ${country}_cert_upload.pem -inkey ${country}_key_upload.pem -name upload -out ${country}_upload.p12 -password "pass:$STORE_PASS"

    echo "Signing $country Auth Cert"
    dgc-cli ta sign -c cert_ta.pem -k key_ta.pem -i ${country}_cert_auth.pem > ${country}_cert_auth_signing.txt
    export COUNTRY=$country
    export THUMBPRINT=$(cat ${country}_cert_auth_signing.txt | grep Thumbprint | cut -d' ' -f3)
    export RAW=$(cat ${country}_cert_auth_signing.txt | grep Raw | cut -d' ' -f4)
    export SIGNATURE=$(cat ${country}_cert_auth_signing.txt | grep Signature | cut -d' ' -f3)
    export TYPE="AUTHENTICATION"

    jq ".[. | length] |= . + {\"country\": \"${COUNTRY}\", \"certificate_type\": \"${TYPE}\", \"thumbprint\": \"${THUMBPRINT}\", \"raw_data\": \"${RAW}\", \"signature\": \"${SIGNATURE}\"}" trusted-parties.json > trusted-parties.json.tmp && \
        mv trusted-parties.json.tmp trusted-parties.json

    echo "Signing $country CSCA Cert"
    dgc-cli ta sign -c cert_ta.pem -k key_ta.pem -i ${country}_cert_csca.pem > ${country}_cert_csca_signing.txt
    export COUNTRY=$country
    export THUMBPRINT=$(cat ${country}_cert_csca_signing.txt | grep Thumbprint | cut -d' ' -f3)
    export RAW=$(cat ${country}_cert_csca_signing.txt | grep Raw | cut -d' ' -f4)
    export SIGNATURE=$(cat ${country}_cert_csca_signing.txt | grep Signature | cut -d' ' -f3)
    export TYPE="CSCA"

    jq ".[. | length] |= . + {\"country\": \"${COUNTRY}\", \"certificate_type\": \"${TYPE}\", \"thumbprint\": \"${THUMBPRINT}\", \"raw_data\": \"${RAW}\", \"signature\": \"${SIGNATURE}\"}" trusted-parties.json > trusted-parties.json.tmp && \
        mv trusted-parties.json.tmp trusted-parties.json

    echo "Signing $country Upload Cert"
    dgc-cli ta sign -c cert_ta.pem -k key_ta.pem -i ${country}_cert_upload.pem > ${country}_cert_upload_signing.txt
    export COUNTRY=$country
    export THUMBPRINT=$(cat ${country}_cert_upload_signing.txt | grep Thumbprint | cut -d' ' -f3)
    export RAW=$(cat ${country}_cert_upload_signing.txt | grep Raw | cut -d' ' -f4)
    export SIGNATURE=$(cat ${country}_cert_upload_signing.txt | grep Signature | cut -d' ' -f3)
    export TYPE="UPLOAD"

    jq ".[. | length] |= . + {\"country\": \"${COUNTRY}\", \"certificate_type\": \"${TYPE}\", \"thumbprint\": \"${THUMBPRINT}\", \"raw_data\": \"${RAW}\", \"signature\": \"${SIGNATURE}\"}" trusted-parties.json > trusted-parties.json.tmp && \
        mv trusted-parties.json.tmp trusted-parties.json
}

generate_country IE

echo "DONE"
