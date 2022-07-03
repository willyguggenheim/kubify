#!/bin/sh

#gen the ca for local.kubify.local, trust on local
apk add openssl
openssl genrsa -des3 -out ca.key 2048
openssl req -x509 -new -nodes -key ca.key -sha256 -days 1825 -out ca.pem -config req.cnf
sudo security add-trusted-cert -d -r trustRoot -k "/Library/Keychains/System.keychain" ca.pem
#gen the cert for *.local.kubify.local, trust on local
openssl req -new -key ca.key -out cert.csr -config req.cnf
openssl x509 -req -in cert.csr -CA ca.pem -CAkey ca.key -CAcreateserial -out ca.crt -days 825 -sha256 -extfile req.cnf
sudo security add-trusted-cert -d -r trustRoot -k "/Library/Keychains/System.keychain" ca.crt

cat ca.pem ca.crt > combined.crt
mv ca.crt just_the.crt
mv ca.key ca_with_passphrase.key
openssl rsa -in ca_with_passphrase.key -out ca.key
