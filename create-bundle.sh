#!/bin/bash

# ✅ Prerequisities:
# 1. Git clone the learn-nestjs repo
# 2. Python3 should be available on machine using (running) this script
# 3. A supported machine (e.g. Ubuntu 20.04) where you are supposed to run this script.
# 4. Followng are alos required. Install: apt install build-essential python3 python3-pip

# (Nexe needs a supported platform to build the nodejs. 
# Check https://github.com/nodejs/node/blob/main/BUILDING.md#supported-platforms for more information.)

# Execute this bash script at the project's root directory
# Note: This script may take 2-3 hours to complete as building node takes time.

set -e

BUNDLE="code-nav-bundle"
DIST=dist
MAIN=main.js

if ! command -v node &> /dev/null; then
    echo "Node is not installed."
    echo "Installing the Node 20"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
    \. "$HOME/.nvm/nvm.sh"
    nvm install 20
else
    echo "Node is already installed"
    node -v
    npm -v
fi

if ! command -v nexe &> /dev/null; then
    echo "⚠️  nexe is not installed."
    echo "📦 Installing the nexe"
    npm install -g nexe
else
    echo "nexe is already installed"
    nexe -v
fi

echo "⚠️  Deleting exisiting $DIST and node_modules directories"
rm -rf $DIST
rm -rf node_modules

echo "📦 Installing the project's dependencies"
npm install

echo "🔧 Creating the project's 'build'"
npm run build

echo "📦 Creating the single-file bundle (or executable) using Nexe"
nexe $DIST/$MAIN -o $BUNDLE --python=$(which python3) --verbose --build --make="-j4"

echo "🔧 Adding execute permission to the bundle file"
#chmod +x $BUNDLE

echo "✅ Executable $BUNDLE is ready"

