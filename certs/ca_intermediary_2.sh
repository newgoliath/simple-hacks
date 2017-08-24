#!/bin/bash

# create a Certificate Authority in $PWD

DIR="${DIR:-`pwd`}"
echo "Working directory: ${DIR}"
cd ${DIR}

CA_DIR=${DIR}/ca
cd ${CA_DIR}

# create the second intermediate cert to be used in OpenShift
INTER_DIR=${CA_DIR}/intermediate2
mkdir ${INTER_DIR}
cd ${INTER_DIR}
mkdir certs crl csr newcerts private
chmod 700 private
touch index.txt
echo 1000 > serial
echo 1000 > ${INTER_DIR}/crlnumber

# create intermediate2 key
echo --- creating the INTERMEDIARY KEY
#openssl genrsa \#h-aes256 \
openssl genrsa -out ${INTER_DIR}/private/intermediate2.key.pem 4096
#      -passout pass:intermed_key \

# create intermediate2 cert

# create cert signing request
echo --- creating the INTERMEDIARY CSR
openssl req -config ${DIR}/intermediate2_ca_openssl.cnf -new -sha256 \
      -key ${INTER_DIR}/private/intermediate2.key.pem \
      -out ${INTER_DIR}/csr/intermediate2.csr.pem
#      -passin pass:intermed_key \
#      -passout pass:intermed_csr \
      #-subj '/CN=www.mydom.com/O=My Company Name LTD./C=US' \

echo --- creating the INTERMEDIARY CERT
openssl ca -config ${DIR}/root_ca_openssl.cnf -extensions v3_intermediate_ca \
      -days 3650 -notext -md sha256 \
      -in ${INTER_DIR}/csr/intermediate2.csr.pem \
      -out ${INTER_DIR}/certs/intermediate2.cert.pem
      #-passin pass:intermed_csr \
      #-passin pass:password1 \


# verify the chain
echo --- verifying the Intermediate cert
openssl verify -CAfile ${CA_DIR}/certs/ca.cert.pem \
      ${INTER_DIR}/certs/intermediate2.cert.pem

