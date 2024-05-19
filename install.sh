#!/bin/bash

# Define the application name
APP_NAME="starter-go"
# Define the application name
GITHUB_USER="danielleitelima"

# Detect OS and architecture
OS=$(uname -s)
ARCH=$(uname -m)

# Fetch the latest release data from GitHub
RELEASE_JSON=$(curl -s https://api.github.com/repos/${GITHUB_USER}/${APP_NAME}/releases/latest)

# Determine the correct asset suffix based on OS and architecture
case "$OS" in
    Linux)
        case "$ARCH" in
            x86_64)
                ASSET_SUFFIX="_Linux_x86_64.tar.gz"
                ;;
            arm64)
                ASSET_SUFFIX="_Linux_arm64.tar.gz"
                ;;
            i386)
                ASSET_SUFFIX="_Linux_i386.tar.gz"
                ;;
            *)
                echo "Error: Unsupported architecture: $ARCH"
                exit 1
                ;;
        esac
        ;;
    Darwin)
        case "$ARCH" in
            x86_64)
                ASSET_SUFFIX="_Darwin_x86_64.tar.gz"
                ;;
            arm64)
                ASSET_SUFFIX="_Darwin_arm64.tar.gz"
                ;;
            *)
                echo "Error: Unsupported architecture: $ARCH"
                exit 1
                ;;
        esac
        ;;
    MINGW*|MSYS*|CYGWIN*)
        case "$ARCH" in
            x86_64)
                ASSET_SUFFIX="_Windows_x86_64.tar.gz"
                ;;
            arm64)
                ASSET_SUFFIX="_Windows_arm64.tar.gz"
                ;;
            i386)
                ASSET_SUFFIX="_Windows_i386.tar.gz"
                ;;
            *)
                echo "Error: Unsupported architecture: $ARCH"
                exit 1
                ;;
        esac
        ;;
    *)
        echo "Error: Unsupported OS: $OS"
        exit 1
        ;;
esac

# Extract the URL for the desired asset without using jq
URL=$(echo "$RELEASE_JSON" | grep -o 'https://[^"]*' | grep "$ASSET_SUFFIX$")

if [ -z "$URL" ]; then
    echo "Error: Could not find the URL for the asset with suffix: $ASSET_SUFFIX"
    exit 1
fi

# Set the installation directory
if [[ "$OS" == "MINGW"* || "$OS" == "MSYS"* || "$OS" == "CYGWIN"* ]]; then
    INSTALL_DIR="/c/Program Files/${APP_NAME}"
else
    INSTALL_DIR="/usr/local/bin"
fi

# Ensure the installation directory exists (no need to create if it already exists)
if [ ! -d "$INSTALL_DIR" ]; then
    echo "Creating directory $INSTALL_DIR"
    sudo mkdir -p "$INSTALL_DIR"
fi

# Download and extract the application to a temporary directory
TEMP_DIR=$(mktemp -d)
if curl -sL "$URL" | tar xz -C "$TEMP_DIR"; then
    echo "${APP_NAME} downloaded and extracted successfully."
else
    echo "Error: Failed to download or extract the application."
    exit 1
fi

# Move the binaries to the installation directory
echo "Updating binaries in $INSTALL_DIR"
if sudo cp -r "$TEMP_DIR"/* "$INSTALL_DIR"; then
    echo "Binaries updated successfully."
else
    echo "Error: Failed to copy binaries. You might need to run this script with sudo."
    exit 1
fi

# Clean up the temporary directory
rm -rf "$TEMP_DIR"

# Add the installation directory to PATH if not already present
if ! echo "$PATH" | grep -q "$INSTALL_DIR"; then
    echo "Adding $INSTALL_DIR to PATH"
    if [ "$OS" == "Darwin" ] || [ "$OS" == "Linux" ]; then
        PROFILE_FILE="/etc/profile.d/${APP_NAME}.sh"
        echo "export PATH=\$PATH:$INSTALL_DIR" | sudo tee "$PROFILE_FILE"
        source "$PROFILE_FILE"
        echo "Installation directory added to PATH in $PROFILE_FILE."
    elif [[ "$OS" == "MINGW"* || "$OS" == "MSYS"* || "$OS" == "CYGWIN"* ]]; then
        echo "export PATH=\$PATH:$INSTALL_DIR" >> ~/.bashrc
        source ~/.bashrc
        echo "Installation directory added to PATH in ~/.bashrc."
    else
        echo "Warning: Unable to determine the profile file to update. Please manually add $INSTALL_DIR to your PATH."
    fi
else
    echo "$INSTALL_DIR is already in the PATH."
fi

echo "${APP_NAME} installed and updated successfully."
