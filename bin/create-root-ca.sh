#!/bin/bash

#### CA Parameter
CONFIG=$(dirname $0)/../etc/config.sh
. ${CONFIG}

# Create private key ca-key.pem
openssl genrsa -aes256 -out ${caprivatekeyfile} ${cakeylength}

# Create Root Certificate for import into browsers etc.
openssl req -x509 -new -nodes -extensions v3_ca -sha512 \
	    -key ${caprivatekeyfile} \
	    -days ${cakeyvalidity} \
	    -out ${carootcertificate} \
            -subj "/C=${C}/ST=${ST}/L=${L}/O=${O}/OU=${OU}/CN=$fqdn/emailAddress=$email"

# Install Root CA on Fedora/RHEL as trusted
echo "Installing CA as trusted"
sudo cp ${carootcertificate} /etc/pki/ca-trust/source/anchors/
sudo update-ca-trust

