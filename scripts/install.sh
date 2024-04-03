#!/bin/bash

# URLs for the assets
binary_url=$(curl -s https://api.github.com/repos/rotkonetworks/genpeerid/releases/latest | grep -oP '"browser_download_url": "\K(.*genpeerid)(?=")')
binary_signature_url=$(curl -s https://api.github.com/repos/rotkonetworks/genpeerid/releases/latest | grep -oP '"browser_download_url": "\K(.*genpeerid.sig)(?=")')
hash_url=$(curl -s https://api.github.com/repos/rotkonetworks/genpeerid/releases/latest | grep -oP '"browser_download_url": "\K(.*genpeerid.sha512)(?=")')
hash_signature_url=$(curl -s https://api.github.com/repos/rotkonetworks/genpeerid/releases/latest | grep -oP '"browser_download_url": "\K(.*genpeerid.sha512.sig)(?=")')
public_key_url="https://github.com/hitchhooker.gpg"

# Download the binary, SHA512 hash, and the GPG signature of the hash
curl -sL "${binary_url}" -o genpeerid
curl -sL "${binary_signature_url}" -o genpeerid.sig
curl -sL "${hash_url}" -o genpeerid.sha512
curl -sL "${hash_signature_url}" -o genpeerid.sha512.sig
curl -sL "${public_key_url}" -o public_key.gpg

# Import the public key
gpg --import public_key.gpg

echo "Verifying SHA512 hash..."
sha512sum -c genpeerid.sha512 || { echo "SHA512 verification failed!"; exit 1; }

# Verify the GPG signature of the SHA512 hash
echo "Verifying GPG signature of SHA512 hash..."
gpg --verify genpeerid.sha512.sig genpeerid.sha512 || { echo "GPG signature verification of SHA512 hash failed!"; exit 1; }

# New Step: Verify the GPG signature of the binary itself
echo "Verifying GPG signature of the binary..."
gpg --verify genpeerid.sig genpeerid || { echo "GPG signature verification of the binary failed!"; exit 1; }

# If all verifications passed, proceed to use the binary
chmod +x genpeerid
./genpeerid
