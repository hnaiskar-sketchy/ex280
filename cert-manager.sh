#!/bin/bash

# ==============================================
# Script: certmanager.sh
# Purpose: Generate a self-signed SSL certificate and key interactively
# ==============================================

echo "=== Self-Signed Certificate Generator ==="

# Prompt for certificate details
read -p "Common Name (e.g. example.com): " COMMON_NAME
read -p "Organizational Unit (OU): " ORG_UNIT
read -p "Organization Name (O): " ORG_NAME
read -p "Locality Name (L): " LOCALITY
read -p "State Name (ST): " STATE
read -p "Country Name (2 letter code, e.g. US): " COUNTRY

# Set output filenames
CERT_FILE="${COMMON_NAME}.crt"
KEY_FILE="${COMMON_NAME}.key"
CSR_FILE="${COMMON_NAME}.csr"

# Display entered information
echo ""
echo "You entered:"
echo "  Common Name (CN): $COMMON_NAME"
echo "  Organizational Unit (OU): $ORG_UNIT"
echo "  Organization Name (O): $ORG_NAME"
echo "  Locality (L): $LOCALITY"
echo "  State (ST): $STATE"
echo "  Country (C): $COUNTRY"
echo ""
read -p "Do you want to continue and generate the certificate? (y/n): " CONFIRM

if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
  echo "Cancelled."
  exit 1
fi

# Generate private key
openssl genrsa -out "$KEY_FILE" 2048

# Generate CSR (Certificate Signing Request)
openssl req -new -key "$KEY_FILE" -out "$CSR_FILE" \
  -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORG_NAME/OU=$ORG_UNIT/CN=$COMMON_NAME"

# Generate self-signed certificate (valid for 365 days)
openssl x509 -req -days 365 -in "$CSR_FILE" -signkey "$KEY_FILE" -out "$CERT_FILE"

# Cleanup CSR file
rm -f "$CSR_FILE"

echo ""
echo "✅ Self-signed certificate and key generated successfully!"
echo "Certificate: $CERT_FILE"
echo "Private Key: $KEY_FILE"
echo "==============================================="

