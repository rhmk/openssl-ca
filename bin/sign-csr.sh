#!/bin/bash

CONFIG=$(dirname $0)/../etc/config.sh
. ${CONFIG}

usage() {
	echo "USAGE: $(basename $0) certifcate-request"
	exit 1
}
cleanup() { 
	[ -f ${extv3} ] && rm -f ${extv3} 
}
trap 'cleanup' 0

[ $# -ne 1 ] && usage

echo "Signing Certificate $csr"

csr=$1
extv3=$(mktemp -u -t X509v3_XXXX_ext.cnf)


#### Read more paramters:
#
echo -n "Enter FQDN: "; read fqdn
ip=$(dig $fqdn +short +search)
if [ -z "$ip" ]; then
        echo "Enter IP:"; read ip
else
        echo "IP: $ip"
fi

# Create X509v3 extension
cat > ${extv3} << EOF
[ req_ext ]
subjectAltName                  = @alt_names

[alt_names]
DNS = ${fqdn}
email = ${email}
IP = ${ip}
URI = http://${fqdn}/

EOF

if openssl req -text -noout -verify -in ${csr} >/dev/null 2>&1; then
	# valid csr found
	openssl x509 -req -in ${csr} \
		-CA ${carootcertificate} \
		-CAkey ${caprivatekeyfile} \
		-CAcreateserial -out ${csr%.*}.crt \
		-days ${default_validity}  -sha512 \
		-extfile ${extv3} -extensions req_ext
 	# create keybundle
	echo "Create Bundle with key and root ca"
        cat ${carootcertificate} >> ${csr%.*}-bundle.pem
	# cleanup
	rm ${extv3}
else
	echo "No CSR or invalid CSR"
	usage
fi

