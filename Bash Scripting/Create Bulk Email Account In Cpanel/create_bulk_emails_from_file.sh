#!/bin/bash

# Script to create email accounts in cPanel from a text file with email prefixes
# Generates random passwords and outputs results to a CSV file

# Check if domain and input file are provided as arguments
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <domain.com> <input_file.txt>"
    echo "Example: $0 example.com email_prefixes.txt"
    exit 1
fi

DOMAIN="$1"
INPUT_FILE="$2"
CPANEL_USER=$(whmapi1 getdomainowner domain="$DOMAIN" | grep -oP 'user: \K\S+')
if [ -z "$CPANEL_USER" ]; then
    echo "Error: Domain $DOMAIN not found or not associated with a cPanel user."
    exit 1
fi

if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file $INPUT_FILE not found."
    exit 1
fi

OUTPUT_FILE="/root/email_accounts_$(date +%F_%H-%M-%S).txt"
echo "Email accounts and passwords will be saved to $OUTPUT_FILE"
echo "Email,Password" > "$OUTPUT_FILE"

COUNT=0
SKIPPED=0
while IFS= read -r EMAIL_PREFIX; do
    # Skip empty lines
    if [ -z "$EMAIL_PREFIX" ]; then
        echo "Skipping empty line in $INPUT_FILE."
        ((SKIPPED++))
        continue
    fi

    # Validate email prefix (letters, numbers, periods, hyphens, underscores only)
    if ! [[ "$EMAIL_PREFIX" =~ ^[a-zA-Z0-9._-]+$ ]]; then
        echo "Error: Invalid email prefix '$EMAIL_PREFIX'. Use letters, numbers, periods, hyphens, or underscores only."
        echo "Skipped: $EMAIL_PREFIX@$DOMAIN,Invalid prefix" >> "$OUTPUT_FILE"
        ((SKIPPED++))
        continue
    fi
    if [ ${#EMAIL_PREFIX} -gt 64 ]; then
        echo "Error: Email prefix '$EMAIL_PREFIX' too long (max 64 characters)."
        echo "Skipped: $EMAIL_PREFIX@$DOMAIN,Prefix too long" >> "$OUTPUT_FILE"
        ((SKIPPED++))
        continue
    fi

    # Generate random password (16 characters, alphanumeric + symbols)
    PASSWORD=$(openssl rand -base64 12 | tr -dc 'a-zA-Z0-9!@#$%^&*()')

    # Create email account using UAPI
    RESULT=$(uapi --user="$CPANEL_USER" Email add_pop email="$EMAIL_PREFIX" password="$PASSWORD" domain="$DOMAIN" quota=100 2>&1)
    if echo "$RESULT" | grep -q '"result":1'; then
        echo "Created email: $EMAIL_PREFIX@$DOMAIN"
        echo "$EMAIL_PREFIX@$DOMAIN,$PASSWORD" >> "$OUTPUT_FILE"
        ((COUNT++))
    else
        echo "Failed to create $EMAIL_PREFIX@$DOMAIN: $RESULT"
        echo "Failed: $EMAIL_PREFIX@$DOMAIN,$RESULT" >> "$OUTPUT_FILE"
        ((SKIPPED++))
    fi
done < "$INPUT_FILE"

echo "Process completed. $COUNT email accounts created, $SKIPPED entries skipped or failed."
echo "Results saved to $OUTPUT_FILE"
echo "You can view the file with: cat $OUTPUT_FILE"
