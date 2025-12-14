#!/usr/bin/env bash
# Install/manage hjkl-arrows key remapper
# Usage: ./hjkl-arrows.sh [install|uninstall|status|run]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SWIFT_SRC="$SCRIPT_DIR/hjkl-arrows.swift"
INSTALL_DIR="$HOME/.local/bin"
BINARY="$INSTALL_DIR/hjkl-arrows"
PLIST_PATH="$HOME/Library/LaunchAgents/com.dotfiles.hjkl-arrows.plist"

compile() {
    echo "Compiling hjkl-arrows.swift..."
    mkdir -p "$INSTALL_DIR"
    swiftc -O -o "$BINARY" "$SWIFT_SRC"
    echo "Compiled to $BINARY"
}

install_launchagent() {
    mkdir -p "$(dirname "$PLIST_PATH")"
    cat > "$PLIST_PATH" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.dotfiles.hjkl-arrows</string>
    <key>ProgramArguments</key>
    <array>
        <string>$BINARY</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>$HOME/.local/log/hjkl-arrows.log</string>
    <key>StandardErrorPath</key>
    <string>$HOME/.local/log/hjkl-arrows.log</string>
</dict>
</plist>
EOF
    mkdir -p "$HOME/.local/log"
    launchctl load "$PLIST_PATH"
    echo "LaunchAgent installed - runs on login"
}

install() {
    compile
    install_launchagent
    echo ""
    echo "✓ hjkl-arrows installed"
    echo "  Binary: $BINARY"
    echo "  LaunchAgent: $PLIST_PATH"
    echo ""
    echo "Note: Grant Accessibility permission when prompted"
    echo "      System Settings → Privacy & Security → Accessibility"
}

uninstall() {
    launchctl unload "$PLIST_PATH" 2>/dev/null || true
    rm -f "$PLIST_PATH"
    rm -f "$BINARY"
    echo "hjkl-arrows uninstalled"
}

status() {
    if launchctl list | grep -q "com.dotfiles.hjkl-arrows"; then
        echo "Status: RUNNING"
        echo "Binary: $BINARY"
        echo "Log: $HOME/.local/log/hjkl-arrows.log"
    else
        echo "Status: NOT RUNNING"
        if [ -f "$BINARY" ]; then
            echo "Binary exists at $BINARY"
        fi
    fi
}

run_foreground() {
    if [ ! -f "$BINARY" ]; then
        compile
    fi
    exec "$BINARY"
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
    run)
        run_foreground
        ;;
    compile)
        compile
        ;;
    *)
        echo "Usage: $0 [install|uninstall|status|run|compile]"
        exit 1
        ;;
esac
