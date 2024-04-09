#!/bin/bash

set -euo pipefail

# Define locations and names
binary_name="genpeerid"
install_path="/usr/local/bin/${binary_name}"

# Check if genpeerid is already installed and exit if it is
if command -v ${binary_name} &> /dev/null; then
    echo "${binary_name} is already installed."
    exit 0
fi

# Install dependencies if missing, for Debian/Ubuntu systems
if ! command -v gpg &> /dev/null || ! command -v curl &> /dev/null; then
    echo "Installing missing dependencies..."
    sudo apt-get update
    sudo apt-get install -y gpg curl
fi

# URLs for the assets
binary_url=$(curl -s https://api.github.com/repos/rotkonetworks/genpeerid/releases/latest | grep -oP '"browser_download_url": "\K(.*genpeerid)(?=")')
binary_signature_url=$(curl -s https://api.github.com/repos/rotkonetworks/genpeerid/releases/latest | grep -oP '"browser_download_url": "\K(.*genpeerid.sig)(?=")')
hash_url=$(curl -s https://api.github.com/repos/rotkonetworks/genpeerid/releases/latest | grep -oP '"browser_download_url": "\K(.*genpeerid.sha512)(?=")')
hash_signature_url=$(curl -s https://api.github.com/repos/rotkonetworks/genpeerid/releases/latest | grep -oP '"browser_download_url": "\K(.*genpeerid.sha512.sig)(?=")')
public_key_url="https://github.com/hitchhooker.gpg"

# Download the binary, SHA512 hash, and the GPG signature of the hash
curl -sL "${binary_url}" -o ${binary_name}
curl -sL "${binary_signature_url}" -o ${binary_name}.sig
curl -sL "${hash_url}" -o ${binary_name}.sha512
curl -sL "${hash_signature_url}" -o ${binary_name}.sha512.sig
curl -sL "${public_key_url}" -o public_key.gpg

# Import the public key
gpg --import public_key.gpg

echo "Verifying SHA512 hash..."
sha512sum -c ${binary_name}.sha512 || { echo "SHA512 verification failed!"; exit 1; }

echo "Verifying GPG signature of SHA512 hash..."
gpg --verify ${binary_name}.sha512.sig ${binary_name}.sha512 || { echo "GPG signature verification of SHA512 hash failed!"; exit 1; }

echo "Verifying GPG signature of the binary..."
gpg --verify ${binary_name}.sig ${binary_name} || { echo "GPG signature verification of the binary failed!"; exit 1; }

# Ensure the binary is executable
chmod +x ${binary_name}

# Move the binary to the installation path
sudo mv ${binary_name} ${install_path}

echo "${binary_name} installed successfully to ${install_path}."

# Clean up
rm -f ${binary_name}.sha512 ${binary_name}.sha512.sig public_key.gpg ${binary_name}.sig
