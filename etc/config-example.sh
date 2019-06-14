#!/bin/bash

#### CA Parameter
cakeylength=4096
cakeyvalidity=1024
caprivatekeyfile=../etc/ca-keynew.pem
carootcertificate=../etc/ca-rootnew.pem

#### Standard certificate values for signing, creating etc.
email="admin@example.com"
C=DE
ST=state
L=location
O=organization
OU=organisationunit

### CA Common Name
CN="Local CA"

#signed certificate valid 365days
default_validity=365

