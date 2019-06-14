openssl-ca
===========

Simple scriptiong to create my own ca with openssl tools. 

Goal: Create a CA for simple use in my lab and home environments

Inspired by: 
- https://legacy.thomas-leister.de/eine-eigene-openssl-ca-erstellen-und-zertifikate-ausstellen/
- https://serverfault.com/questions/779475/openssl-add-subject-alternate-name-san-when-signing-with-ca
- https://www.happyassassin.net/2015/01/14/trusting-additional-cas-in-fedora-rhel-centos-dont-append-to-etcpkitlscertsca-bundle-crt-or-etcpkitlscert-pem/
- https://serverfault.com/questions/9708/what-is-a-pem-file-and-how-does-it-differ-from-other-openssl-generated-key-file
- https://support.google.com/chrome/a/answer/7391219?hl=de

Installation
============

- clone the folder 
- goto etc and mv config-example.sh to config.sh
- edit config.sh to your needs

Usage
=====

create-root-ca.sh               : Creates your root CA
create-cert-pair.sh <dir> <name>: creates a private key and a signed cert with previously created CA for e.g. a webserver
display-pem.sh <key>            : displays the content of key <key>
sign-csr.sh <csr>               : signs a application generated csr with the above key 
verify-cert.sh <name>           : verifies that a cert is valid against the CA


