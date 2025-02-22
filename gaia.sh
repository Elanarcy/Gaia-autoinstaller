#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# ASCII Name Banner
cat << 'EOF'
 _______  __          ___      .__   __.      ___      .______        ______ ____    ____ 
|   ____||  |        /   \     |  \ |  |     /   \     |   _  \      /      |\   \  /   / 
|  |__   |  |       /  ^  \    |   \|  |    /  ^  \    |  |_)  |    |  ,----' \   \/   /  
|   __|  |  |      /  /_\  \   |  . `  |   /  /_\  \   |      /     |  |       \_    _/   
|  |____ |  `----./  _____  \  |  |\   |  /  _____  \  |  |\  \----.|  `----.    |  |     
|_______||_______/__/     \__\ |__| \__| /__/     \__\ | _| `._____| \______|    |__|     

EOF

# Join our community
echo "Join here: https://t.me/cssurabaya - Many tools for testnets & nodes!"

# Prompt for secret code
read -p "Enter the secret code to start installation: " SECRET

if [[ "$SECRET" != "css" ]]; then
    echo "Incorrect code! Exiting..."
    exit 1
fi

echo "Secret code accepted. Starting installation..."

# Define the installation directory
INSTALL_DIR="$HOME/gaianet-2"

# Create folder
mkdir -p "$INSTALL_DIR"

echo "Installing GaiaNet Node..."
# Install node
curl -sSfL 'https://raw.githubusercontent.com/GaiaNet-AI/gaianet-node/main/install.sh' | bash -s -- --base "$INSTALL_DIR" --ggmlcuda 12

# Automatically source /root/.bashrc before proceeding to the next step
source /root/.bashrc

echo "Installing Qwen2 Model..."
# Install model qwen2
gaianet init --config https://raw.gaianet.ai/qwen2-0.5b-instruct/config.json --base "$INSTALL_DIR"

echo "Changing GaiaNet port to 8075..."
# Change port
gaianet config --port 8075 --base "$INSTALL_DIR"

# Modify frpc.toml file to update port from 8080 to 8075
echo "Updating frpc.toml file..."
sed -i 's/8080/8075/g' "$INSTALL_DIR/gaia-frp/frpc.toml"

echo "Starting GaiaNet Node..."
# Start node
gaianet init --base "$INSTALL_DIR"
gaianet start --base "$INSTALL_DIR"

echo "Fetching Node ID and Device ID..."
# Display node details
gaianet info --base "$INSTALL_DIR"

# Show Node ID and Device ID after successful installation
echo "Installation completed successfully! Your Node ID and Device ID:"
gaianet info --base "$INSTALL_DIR"
