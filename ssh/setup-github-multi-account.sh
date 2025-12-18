#!/bin/bash
# GitHub Multi-Account SSH Setup
# ===============================
# Sets up SSH keys for multiple GitHub accounts with automatic key selection.
# No secrets are stored in this script - keys are generated locally.
#
# Accounts:
#   - rookoor (default, uses github.com)
#   - JesseConstruction (uses github-jesse alias)
#
# Usage:
#   ./setup-github-multi-account.sh [--regenerate]
#
# After running, add the public keys to each GitHub account:
#   - https://github.com/settings/keys

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SSH_DIR="$HOME/.ssh"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Parse arguments
REGENERATE=false
if [[ "$1" == "--regenerate" ]]; then
    REGENERATE=true
fi

# Ensure SSH directory exists with correct permissions
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

# Generate key for rookoor if it doesn't exist
if [[ ! -f "$SSH_DIR/id_ed25519" ]] || [[ "$REGENERATE" == true ]]; then
    if [[ -f "$SSH_DIR/id_ed25519" ]]; then
        warn "Backing up existing rookoor key to id_ed25519.bak"
        mv "$SSH_DIR/id_ed25519" "$SSH_DIR/id_ed25519.bak"
        mv "$SSH_DIR/id_ed25519.pub" "$SSH_DIR/id_ed25519.pub.bak"
    fi
    info "Generating SSH key for rookoor..."
    ssh-keygen -t ed25519 -f "$SSH_DIR/id_ed25519" -C "rookoor@github" -N ""
else
    info "rookoor key already exists at $SSH_DIR/id_ed25519"
fi

# Generate key for JesseConstruction if it doesn't exist
if [[ ! -f "$SSH_DIR/id_ed25519_jesse" ]] || [[ "$REGENERATE" == true ]]; then
    if [[ -f "$SSH_DIR/id_ed25519_jesse" ]]; then
        warn "Backing up existing JesseConstruction key to id_ed25519_jesse.bak"
        mv "$SSH_DIR/id_ed25519_jesse" "$SSH_DIR/id_ed25519_jesse.bak"
        mv "$SSH_DIR/id_ed25519_jesse.pub" "$SSH_DIR/id_ed25519_jesse.pub.bak"
    fi
    info "Generating SSH key for JesseConstruction..."
    ssh-keygen -t ed25519 -f "$SSH_DIR/id_ed25519_jesse" -C "JesseConstruction@github" -N ""
else
    info "JesseConstruction key already exists at $SSH_DIR/id_ed25519_jesse"
fi

# Install SSH config
info "Installing SSH config..."
if [[ -f "$SSH_DIR/config" ]]; then
    # Check if our config is already there
    if grep -q "github-jesse" "$SSH_DIR/config"; then
        info "SSH config already contains github-jesse configuration"
    else
        warn "Existing SSH config found. Backing up to config.bak"
        cp "$SSH_DIR/config" "$SSH_DIR/config.bak"
        cat "$SCRIPT_DIR/config" >> "$SSH_DIR/config"
        info "Appended multi-account config to existing SSH config"
    fi
else
    cp "$SCRIPT_DIR/config" "$SSH_DIR/config"
    info "SSH config installed"
fi
chmod 600 "$SSH_DIR/config"

# Display public keys
echo ""
echo "============================================"
echo "Setup complete! Add these public keys to GitHub:"
echo "============================================"
echo ""
echo -e "${YELLOW}rookoor${NC} - Add to https://github.com/settings/keys"
echo "-------------------------------------------"
cat "$SSH_DIR/id_ed25519.pub"
echo ""
echo -e "${YELLOW}JesseConstruction${NC} - Add to https://github.com/settings/keys"
echo "(Log in as JesseConstruction first)"
echo "-------------------------------------------"
cat "$SSH_DIR/id_ed25519_jesse.pub"
echo ""
echo "============================================"
echo "Usage after setup:"
echo "============================================"
echo "  rookoor repos:          git clone git@github.com:rookoor/repo.git"
echo "  JesseConstruction repos: git clone git@github-jesse:JesseConstruction/repo.git"
echo ""
echo "Test connectivity:"
echo "  ssh -T git@github.com        # Should show rookoor"
echo "  ssh -T git@github-jesse      # Should show JesseConstruction"
echo ""
