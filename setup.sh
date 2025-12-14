#!/usr/bin/env bash
# Unified Setup Script
# Quick setup for a new machine - keys, settings, configs
# Usage: ./setup.sh [all|keys|settings|configs]

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
else
    echo -e "${RED}Unsupported OS: $OSTYPE${NC}"
    exit 1
fi

echo -e "${GREEN}Detected OS: $OS${NC}"

# ============================================
# KEY REMAPPING
# ============================================
setup_keys() {
    print_header "Key Remapping"

    if [[ "$OS" == "macos" ]]; then
        echo "Setting up Caps↔Esc swap (hidutil)..."
        bash "$DOTFILES_DIR/keys/macos/caps-esc.sh" install

        echo ""
        echo "Setting up Cmd+HJKL → Arrows..."
        bash "$DOTFILES_DIR/keys/macos/hjkl-arrows.sh" install

        echo ""
        echo -e "${YELLOW}Note: Grant Accessibility permission when prompted${NC}"
        echo "  System Settings → Privacy & Security → Accessibility"

    elif [[ "$OS" == "linux" ]]; then
        echo "Setting up keyd (Caps↔Esc + Super+HJKL)..."
        sudo bash "$DOTFILES_DIR/keys/linux/install.sh" install
    fi

    echo ""
    echo -e "${GREEN}✓ Key remapping configured${NC}"
}

# ============================================
# SYSTEM SETTINGS
# ============================================
setup_settings() {
    print_header "System Settings"

    if [[ "$OS" == "macos" ]]; then
        bash "$DOTFILES_DIR/settings/macos.sh" apply
    elif [[ "$OS" == "linux" ]]; then
        bash "$DOTFILES_DIR/settings/linux.sh" apply
    fi

    echo ""
    echo -e "${GREEN}✓ System settings configured${NC}"
}

# ============================================
# CONFIG SYMLINKS
# ============================================
setup_configs() {
    print_header "Config Files"

    # Create backup directory
    backup_dir="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"

    symlink_file() {
        local source="$1"
        local target="$2"

        if [ -e "$target" ] || [ -L "$target" ]; then
            echo "  Backing up $target"
            mv "$target" "$backup_dir/"
        fi

        mkdir -p "$(dirname "$target")"
        ln -sf "$source" "$target"
        echo "  ✓ Linked $target"
    }

    # Bash
    [ -f "$DOTFILES_DIR/bash/.bashrc" ] && symlink_file "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"
    [ -f "$DOTFILES_DIR/bash/.bash_profile" ] && symlink_file "$DOTFILES_DIR/bash/.bash_profile" "$HOME/.bash_profile"

    # Git
    [ -f "$DOTFILES_DIR/git/.gitconfig" ] && symlink_file "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"

    # Tmux
    [ -f "$DOTFILES_DIR/tmux/.tmux.conf" ] && symlink_file "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"

    # Neovim
    [ -d "$DOTFILES_DIR/nvim" ] && symlink_file "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

    # Ghostty
    [ -f "$DOTFILES_DIR/ghostty/config" ] && symlink_file "$DOTFILES_DIR/ghostty/config" "$HOME/.config/ghostty/config"

    # Qutebrowser
    [ -f "$DOTFILES_DIR/qutebrowser/config.py" ] && symlink_file "$DOTFILES_DIR/qutebrowser/config.py" "$HOME/.config/qutebrowser/config.py"

    echo ""
    echo -e "${YELLOW}Backup location: $backup_dir${NC}"
    echo -e "${GREEN}✓ Config files linked${NC}"
}

# ============================================
# MAIN
# ============================================
usage() {
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  all       Run everything (default)"
    echo "  keys      Set up key remapping only"
    echo "  settings  Apply system settings only"
    echo "  configs   Symlink config files only"
    echo "  status    Show current status"
    echo ""
}

show_status() {
    print_header "Status"

    echo "OS: $OS"
    echo ""

    echo "Key Remapping:"
    if [[ "$OS" == "macos" ]]; then
        bash "$DOTFILES_DIR/keys/macos/caps-esc.sh" status 2>/dev/null || echo "  Caps↔Esc: not configured"
        bash "$DOTFILES_DIR/keys/macos/hjkl-arrows.sh" status 2>/dev/null || echo "  HJKL→Arrows: not configured"
    else
        bash "$DOTFILES_DIR/keys/linux/install.sh" status 2>/dev/null || echo "  keyd: not configured"
    fi

    echo ""
    echo "Settings:"
    if [[ "$OS" == "macos" ]]; then
        bash "$DOTFILES_DIR/settings/macos.sh" show
    else
        bash "$DOTFILES_DIR/settings/linux.sh" show
    fi
}

case "${1:-all}" in
    all)
        setup_keys
        setup_settings
        setup_configs
        print_header "Setup Complete!"
        echo ""
        echo "You may need to:"
        echo "  1. Restart your terminal"
        echo "  2. Grant Accessibility permissions (macOS)"
        echo "  3. Log out/in for some settings"
        ;;
    keys)
        setup_keys
        ;;
    settings)
        setup_settings
        ;;
    configs)
        setup_configs
        ;;
    status)
        show_status
        ;;
    -h|--help|help)
        usage
        ;;
    *)
        echo "Unknown command: $1"
        usage
        exit 1
        ;;
esac
