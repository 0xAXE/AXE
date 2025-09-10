#!/usr/bin/env bash
set -e

echo "🚀 Setting up AXE development environment..."

# Install dependencies
apt-get update && apt-get install -y curl git build-essential


# Install asdf
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
echo '. "$HOME/.asdf/asdf.sh"' >> ~/.bashrc
echo '. "$HOME/.asdf/completions/asdf.bash"' >> ~/.bashrc
. ~/.asdf/asdf.sh

# Add and install plugins
asdf plugin add scarb || true
asdf install scarb 2.11.4
asdf global scarb 2.11.4


asdf plugin add starknet-foundry || true
asdf install starknet-foundry 0.44.0
asdf global starknet-foundry 0.44.0


echo "✅ AXE Is Ready To Flyy !"