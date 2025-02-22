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

# Prompt the user before proceeding
read -p "Please type 'ok' to automatically run 'source /root/.bashrc' and continue: " RESPONSE
if [[ "$RESPONSE" == "ok" ]]; then
    source /root/.bashrc
    # Check if 'gaianet' is now available
    if ! command -v gaianet &> /dev/null; then
        echo "gaianet command not found after sourcing /root/.bashrc."
        # Attempt to update PATH assuming the binary is in $INSTALL_DIR/bin
        if [ -d "$INSTALL_DIR/bin" ]; then
            export PATH="$INSTALL_DIR/bin:$PATH"
            echo "Updated PATH: $PATH"
            # Recheck for the gaianet command
            if ! command -v gaianet &> /dev/null; then
                echo "gaianet still not found. Please verify the installation."
                exit 1
            fi
        else
            echo "Directory $INSTALL_DIR/bin not found. Please verify the installation."
            exit 1
        fi
    fi
else
    echo "Confirmation not received. Exiting..."
    exit 1
fi

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

echo "Installation completed successfully! Your Node ID and Device ID:"
gaianet info --base "$INSTALL_DIR"
