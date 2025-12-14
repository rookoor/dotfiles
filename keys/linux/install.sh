#!/usr/bin/env bash
# Install keyd key remapping on Linux
# Usage: ./install.sh [install|uninstall|status]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KEYD_CONF="$SCRIPT_DIR/keyd.conf"

check_keyd() {
    if ! command -v keyd &> /dev/null; then
        echo "keyd not found. Installing..."

        if command -v apt &> /dev/null; then
            # Debian/Ubuntu - build from source (not in repos)
            sudo apt install -y git build-essential
            git clone https://github.com/rvaiya/keyd /tmp/keyd
            cd /tmp/keyd
            make && sudo make install
            sudo systemctl enable keyd
            rm -rf /tmp/keyd
        elif command -v pacman &> /dev/null; then
            # Arch - available in AUR or community
            if command -v yay &> /dev/null; then
                yay -S keyd
            else
                sudo pacman -S keyd
            fi
        elif command -v dnf &> /dev/null; then
            # Fedora - build from source
            sudo dnf install -y git gcc make
            git clone https://github.com/rvaiya/keyd /tmp/keyd
            cd /tmp/keyd
            make && sudo make install
            sudo systemctl enable keyd
            rm -rf /tmp/keyd
        else
            echo "Error: Unsupported distro. Install keyd manually:"
            echo "  https://github.com/rvaiya/keyd"
            exit 1
        fi
    fi
}

install() {
    check_keyd

    echo "Installing keyd config..."
    sudo mkdir -p /etc/keyd
    sudo cp "$KEYD_CONF" /etc/keyd/default.conf
    sudo systemctl restart keyd

    echo ""
    echo "✓ keyd installed and configured"
    echo "  Config: /etc/keyd/default.conf"
    echo ""
    echo "Active remappings:"
    echo "  - Caps Lock ↔ Escape"
    echo "  - Super+HJKL → Arrow keys"
}

uninstall() {
    echo "Removing keyd config..."
    sudo rm -f /etc/keyd/default.conf
    sudo systemctl restart keyd
    echo "keyd config removed (keyd still installed)"
}

status() {
    if systemctl is-active --quiet keyd; then
        echo "Status: RUNNING"
        echo "Config: /etc/keyd/default.conf"
        if [ -f /etc/keyd/default.conf ]; then
            echo ""
            echo "Current config:"
            cat /etc/keyd/default.conf
        fi
    else
        echo "Status: NOT RUNNING"
        echo "Start with: sudo systemctl start keyd"
    fi
}

case "${1:-install}" in
    install)
        install
        ;;
    uninstall)
        uninstall
        ;;
    status)
        status
        ;;
    *)
        echo "Usage: $0 [install|uninstall|status]"
        exit 1
        ;;
esac
