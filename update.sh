#!/usr/bin/env bash

# Dotfiles Update Script
# Pull latest changes and re-symlink files

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Updating dotfiles...${NC}"

# Get the directory where this script is located
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd "$DOTFILES_DIR"

# Check if we're in a git repository
if [ ! -d .git ]; then
    echo "Error: Not a git repository"
    exit 1
fi

# Pull latest changes
echo -e "${BLUE}→${NC} Pulling latest changes from git..."
git pull origin main

# Update Homebrew packages
echo -e "${BLUE}→${NC} Updating Homebrew packages..."
brew bundle --file="$DOTFILES_DIR/Brewfile"

# Re-run symlink setup
echo -e "${BLUE}→${NC} Re-symlinking configuration files..."
./install.sh

echo -e "${GREEN}✓${NC} Dotfiles updated successfully!"
