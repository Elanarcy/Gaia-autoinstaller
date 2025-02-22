#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# ASCII Name Banner
echo -e "\n\
 _______  __          ___      .__   __.      ___      .______        ______ ____    ____ \n\
|   ____||  |        /   \     |  \ |  |     /   \     |   _  \      /      |\   \  /   / \n\
|  |__   |  |       /  ^  \    |   \|  |    /  ^  \    |  |_)  |    |  ,----' \   \/   /  \n\
|   __|  |  |      /  /_\  \   |  . \`  |   /  /_\  \   |      /     |  |       \_    _/   \n\
|  |____ |  `----./  _____  \  |  |\   |  /  _____  \  |  |\  \----.|  `----.    |  |     \n\
|_______||_______/__/     \__\ |__| \__| /__/     \__\ | _| \`._____| \______|    |__|     \n\
"

# Join our community
echo "Join here: https://t.me/cssurabaya - Many tools for testnets & nodes!"

# Define the installation directory
INSTALL_DIR="$HOME/gaianet-2"

# Create folder
mkdir -p "$INSTALL_DIR"

echo "Installing GaiaNet Node..."
# Install node
curl -sSfL 'https://raw.githubusercontent.com/GaiaNet-AI/gaianet-node/main/install.sh' | bash -s -- --base "$INSTALL_DIR" --ggmlcuda 12

# Source bashrc before installing Qwen2
source /root/.bashrc

echo "Installing Qwen2 Model..."
# Install model qwen2
gaianet init --config https://raw.gaianet.ai/qwen2-0.5b-instruct/config.json --base "$INSTALL_DIR"

echo "Changing GaiaNet port to 8075..."
# Change port
gaianet config --port 8075 --base "$INSTALL_DIR"

# Modify frpc.toml file to update port from 8080 to 8075
echo "Updating frpc.toml file..."
sed -i 's/8080/8075/g' /root/gaianet-2/gaia-frp/frpc.toml

echo "Starting GaiaNet Node..."
# Start node
gaianet init --base "$INSTALL_DIR"
gaianet start --base "$INSTALL_DIR"

echo "Fetching Node ID and Device ID..."
# Display node details
gaianet info --base "$INSTALL_DIR"

echo "GaiaNet installation and configuration completed successfully!"
