#!/bin/sh

usage() {
echo "USAGE: $(basename $0) keydir name"
exit 1
}

cleanup() { 
	[ -f ${extv3} ] && rm -f ${extv3} 
}
trap 'cleanup' 0


CONFIG=$(dirname $0)/../etc/config.sh
. ${CONFIG}

[ $# -ne 2 ] && usage
[ ! -d "$1" ] && usage

keydir="$1"
keyname="$2"
keylength=4096
priv="${1}/${2}.key"
pub="${1}/${2}.crt"
csr="${1}/${2}.csr"
extv3=$(mktemp -u -t X509v3_XXXX_ext.cnf)


echo "Welcome to Webserver https keypair generation"
echo ""
#### Read more paramters:
#
echo -n "Enter FQDN: "; read fqdn
ip=$(dig $fqdn +short +search)
if [ -z "$ip" ]; then
	echo "Enter IP:"; read ip
else
	echo "IP: $ip"
fi
fqdn2=$(dig -x ${ip} +short)
[ "$fqdn" == "$fqdn2" ] && fqdn2=""
echo "secondary FQDN: $fqdn2"

####
#echo -n "<Enter> to continue" && read a
#### 

# create private key
echo ""
echo "Create private key for $fqdn"
echo ""

[ ! -f ${priv} ] &&\
  openssl genrsa -out ${priv}  ${keylength}

# Create X509v3 extension
cat > ${extv3} << EOF
[req]
default_bits = 4096
default_md = sha256
req_extensions = req_ext
distinguished_name = dn
[ dn ]
[ req_ext ]
subjectAltName = @alt_names
[alt_names]
DNS.1 = ${fqdn}
DNS.2 = ${fqdn2}
email.1 = ${email}
IP.1 = ${ip}
EOF



#create CSR
openssl req -new --nodes -key ${priv} -out ${csr} \
	-sha512  -config ${extv3} \
	-subj "/C=${C}/ST=${ST}/L=${L}/O=${O}/OU=${OU}/CN=$fqdn/emailAddress=$email"

openssl req -text -noout -in ${csr}

echo ""
echo -n "Press Enter to sign this request"
read a
echo ""

# sign CSR for 365 days
openssl x509 -req -in ${csr} \
                  -CA ${carootcertificate} \
		  -CAkey ${caprivatekeyfile} \
		  -CAcreateserial -out ${pub} \
		  -days ${default_validity} -sha512 \
		  -extfile ${extv3} -extensions req_ext

echo ""
echo "Create Bundle with key and root ca"
cat ${carootcertificate} >> ${pub%.csr}-bundle.pem

# todo as trap
rm ${extv3}
