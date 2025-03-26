#!/bin/bash

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Use 'sudo ./install_cyber_tools.sh'."
  exit 1
fi

# Update system
echo "[*] Updating Fedora packages..."
dnf update -y

# Install dependencies
echo "[*] Installing dependencies..."
dnf install -y git python3-pip golang curl wget make gcc openssl-devel bzip2-devel libffi-devel zlib-devel

# Enable RPM Fusion (for additional packages)
echo "[*] Enabling RPM Fusion..."
dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Install cybersecurity tools
echo "[*] Installing core tools..."
dnf install -y \
  nmap wireshark tcpdump john theharvester hydra \
  aircrack-ng sqlmap nikto metasploit-framework burpsuite \
  ghidra binwalk steghide volatility3 autopsy \
  tor proxychains-ng openssh-server openssl

# Install Python-based tools
echo "[*] Installing Python tools..."
pip3 install --upgrade pip
pip3 install \
  scapy pycryptodome requests beautifulsoup4 \
  pwntools impacket

# Install Go-based tools
echo "[*] Installing Go tools..."
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
go install github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
go install github.com/ffuf/ffuf@latest
go install github.com/tomnomnom/httprobe@latest

# Install Snort (IDS)
echo "[*] Installing Snort..."
dnf install -y snort
systemctl enable snort
systemctl start snort

# Install Lynis (Audit Tool)
echo "[*] Installing Lynis..."
dnf install -y lynis

# Install Docker (for containerized tools)
echo "[*] Installing Docker..."
dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
dnf install -y docker-ce docker-ce-cli containerd.io
systemctl enable docker
systemctl start docker

# Install Dockerized tools
echo "[*] Pulling Docker images..."
docker pull kalilinux/kali-rolling
docker pull owasp/zap2docker-stable
docker pull remnux/remnux-tools

# Cleanup
echo "[*] Cleaning up..."
dnf autoremove -y

echo -e "\n[+] Installation complete! Key tools installed:"
echo -e "  - Nmap, Wireshark, Metasploit, Burp Suite"
echo -e "  - Ghidra, Volatility, Autopsy (Forensics)"
echo -e "  - Nuclei, FFuf, SQLMap (Web Testing)"
echo -e "  - Kali Linux Docker image (Full pentest environment)"
echo -e "\nRun 'sudo msfconsole' to start Metasploit or 'docker run -it kalilinux/kali-rolling' for Kali."