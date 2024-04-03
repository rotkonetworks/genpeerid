#!/bin/bash

# URLs for the assets
binary_url=$(curl -s https://api.github.com/repos/rotkonetworks/genpeerid/releases/latest | grep -oP '"browser_download_url": "\K(.*genpeerid)(?=")')
hash_url=$(curl -s https://api.github.com/repos/rotkonetworks/genpeerid/releases/latest | grep -oP '"browser_download_url": "\K(.*genpeerid.sha512)(?=")')
signature_url=$(curl -s https://api.github.com/repos/rotkonetworks/genpeerid/releases/latest | grep -oP '"browser_download_url": "\K(.*genpeerid.sha512.sig)(?=")')
public_key_url="https://github.com/hitchhooker.gpg"

# Download the binary, SHA512 hash, and the GPG signature of the hash
curl -sL "${binary_url}" -o genpeerid
curl -sL "${hash_url}" -o genpeerid.sha512
curl -sL "${signature_url}" -o genpeerid.sha512.sig
curl -sL "${public_key_url}" -o public_key.gpg

# Import the public key
gpg --import public_key.gpg

# Verify the SHA512 hash against the downloaded binary
echo "Verifying SHA512 hash..."
sha512sum -c genpeerid.sha512

if [ $? -ne 0 ]; then
    echo "SHA512 verification failed!"
    exit 1
fi

# Verify the GPG signature of the SHA512 hash
echo "Verifying GPG signature..."
gpg --verify genpeerid.sha512.sig genpeerid.sha512

if [ $? -ne 0 ]; then
    echo "GPG signature verification failed!"
    exit 1
fi

# If all verifications passed, proceed to use the binary
chmod +x genpeerid
./genpeerid
