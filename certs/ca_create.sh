#!/bin/bash

# create a Certificate Authority in $PWD

DIR="${DIR:-`pwd`}"
echo "Working directory: ${DIR}"
cd ${DIR}

# make the basics
echo --- preparing environment
CA_DIR=${DIR}/ca
mkdir ${CA_DIR}
cd ${CA_DIR}
mkdir certs crl newcerts private
chmod 700 private
touch index.txt
echo 1000 > serial

# create the root key
echo --- creating the ROOT CERT
openssl genrsa -out ${CA_DIR}/private/ca.key.pem 4096 
#openssl genrsa -aes256 -passout pass:password1 -out ${CA_DIR}/private/ca.key.pem 4096 
#chmod 400 private/ca.key.pem

echo --- creating the ROOT KEY
# create the root cert
openssl req -config "${DIR}/root_ca_openssl.cnf" \
      -key private/ca.key.pem \
      -new -x509 -days 7300 -sha256 -extensions v3_ca \
      -out ${CA_DIR}/certs/ca.cert.pem 
      #-passin pass:password1 \
      #-passout pass:password1 \
      #-subj '/CN=www.mydom.com/O=My Company Name LTD./C=US'

# create the intermediate cert to be used in OpenShift
INTER_DIR=${CA_DIR}/intermediate
mkdir ${INTER_DIR}
cd ${INTER_DIR}
mkdir certs crl csr newcerts private
chmod 700 private
touch index.txt
echo 1000 > serial
echo 1000 > ${INTER_DIR}/crlnumber

# create intermediate key
echo --- creating the INTERMEDIARY KEY
#openssl genrsa \#h-aes256 \
openssl genrsa -out ${INTER_DIR}/private/intermediate.key.pem 4096
#      -passout pass:intermed_key \

# create intermediate cert

# create cert signing request
echo --- creating the INTERMEDIARY CSR
openssl req -config ${DIR}/intermediate_ca_openssl.cnf -new -sha256 \
      -key ${INTER_DIR}/private/intermediate.key.pem \
      -out ${INTER_DIR}/csr/intermediate.csr.pem
#      -passin pass:intermed_key \
#      -passout pass:intermed_csr \
      #-subj '/CN=www.mydom.com/O=My Company Name LTD./C=US' \

echo --- creating the INTERMEDIARY CERT
openssl ca -config ${DIR}/root_ca_openssl.cnf -extensions v3_intermediate_ca \
      -days 3650 -notext -md sha256 \
      -in ${INTER_DIR}/csr/intermediate.csr.pem \
      -out ${INTER_DIR}/certs/intermediate.cert.pem
      #-passin pass:intermed_csr \
      #-passin pass:password1 \


# verify the chain
echo --- verifying the Intermediate cert
openssl verify -CAfile ${CA_DIR}/certs/ca.cert.pem \
      ${INTER_DIR}/certs/intermediate.cert.pem


echo --- creating the SERVER KEY
SERVER_NAME="loadbalancer.alb1.example.opentlc.com"
openssl genrsa -aes256 \
      -out ${INTER_DIR}/private/${SERVER_NAME}.key.pem 2048

echo --- creating the SERVER CSR
# server key and certificate
openssl req -nodes -new -sha256 \
      -config ${DIR}/${SERVER}.cnf -extensions server_cert \
      -key ${INTER_DIR}/private/${SERVER_NAME}.key.pem \
      -out ${INTER_DIR}/csr/${SERVER_NAME}.csr.pem

echo --- creating the SERVER CERT
openssl ca -config ${DIR}/${SERVER}.cnf -extensions server_cert \
	-days 100 -notext -md sha256 \
	-in ${INTER_DIR}/csr/${SERVER_NAME}.csr.pem \
	-out ${INTER_DIR}/cert/${SERVER_NAME}.cert.pem

echo --- verify the SERVER CERT
openssl x509 -noout -text \
	-in ${INTER_DIR}/cert/${SERVER_NAME}.cert.pem
  -out server.crt -in server.csr

