#!/bin/bash

# Minimal Fedora Cybersecurity Tools Installer
# Run with: sudo ./minimal_cyber_install.sh

if [ "$(id -u)" -ne 0 ]; then
    echo "Run as root: sudo $0"
    exit 1
fi

echo "[*] Updating system..."
dnf update -y

echo "[*] Installing core tools..."
dnf install -y \
    nmap \          # Network scanning
    wireshark \     # Packet analysis
    tcpdump \       # CLI packet capture
    john \          # Password cracking
    hydra \         # Login brute-forcing
    sqlmap \        # SQL injection
    nikto \         # Web server scanner
    python3-pip \   # Python package manager
    git             # Tool downloads

echo "[*] Installing Python tools..."
pip3 install --upgrade pip
pip3 install \
    scapy \         # Packet manipulation
    pycryptodome \  # Cryptography
    requests        # HTTP interactions

echo "[+] Minimal toolkit installed:"
echo "  - Nmap, Wireshark, tcpdump (Network)"
echo "  - John, Hydra (Password attacks)"
echo "  - SQLMap, Nikto (Web)"
echo "  - Scapy, PyCryptodome (Python)"