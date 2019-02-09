#/bin/bash
#
# Author: David Vidal Villamide (aka askhari)
# Description:
# This script will help to secure communication between tiller
#+ and helm client.
#
# If you want a detailed explanation please visit Helm website: https://docs.helm.sh/using_helm/#securing-your-helm-installation
#
# PREREQUISITES:
# This scripts asumes that you already have a kubernetes cluster and your kubeconfig file configured in ~/.kube/config

# Create a private CA.
openssl genrsa -out ./ca.key.pem 4096
openssl req -key ca.key.pem -new -x509 -days 7300 -sha256 -out ca.cert.pem -extensions v3_ca

# Generate tiller and helm keys.
openssl genrsa -out ./tiller.key.pem 4096
openssl genrsa -out ./helm.key.pem 4096

# Generate certificate request. This should be signed by the private CA created in previous steps.
openssl req -key tiller.key.pem -new -sha256 -out tiller.csr.pem
openssl req -key helm.key.pem -new -sha256 -out helm.csr.pem

# Sign the certificate requests.
openssl x509 -req -CA ca.cert.pem -CAkey ca.key.pem -CAcreateserial -in tiller.csr.pem -out tiller.cert.pem -days 730
openssl x509 -req -CA ca.cert.pem -CAkey ca.key.pem -CAcreateserial -in helm.csr.pem -out helm.cert.pem  -days 730

# Show what helm would do with the certificates.
helm init --dry-run --debug --tiller-tls --tiller-tls-cert ./tiller.cert.pem --tiller-tls-key ./tiller.key.pem --tiller-tls-verify --tls-ca-cert ca.cert.pem --tiller-namespace=tiller-domains --service-account=tiller

# Uncomment the lines below to actually configure tiller and helm client
cat <<EOF
# Configure helm and tiller
helm init --tiller-tls --tiller-tls-cert ./tiller.cert.pem --tiller-tls-key ./tiller.key.pem --tiller-tls-verify --tls-ca-cert ca.cert.pem --tiller-namespace=tiller-domains --service-account=tiller

# Testing our configuration
helm ls --tls --tls-ca-cert ca.cert.pem --tls-cert helm.cert.pem --tls-key helm.key.pem

# Copying CA and client certificates to helm home to shorten helm commands
cp ca.cert.pem $(helm home)/ca.pem
cp helm.cert.pem $(helm home)/cert.pem
cp helm.key.pem $(helm home)/key.pem

# Testing helm.
helm ls --tls
EOF
