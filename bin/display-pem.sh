#!/bin/bash

[ $# -ne 1 ] && exit 1

f=$1
typ=$(file $f  | cut -d: -f2-)
file $f

case $typ in
	" PEM RSA private key")
		openssl rsa -in $f -check
		;;
	" PEM certificate")
		openssl x509 -in $1 -text -noout 
		;;
	" PEM certificate request" )
		openssl req -text -noout -verify -in $1
		;;
	*)
		echo "unknown certifcate type"
		exit 1
		;;

esac
