#!/usr/bin/env bash
# Swap Caps Lock and Escape using hidutil (no bloat, built into macOS)
# Usage: ./caps-esc.sh [install|uninstall|status]

set -e

PLIST_PATH="$HOME/Library/LaunchAgents/com.dotfiles.caps-esc.plist"

# hidutil key codes (USB HID usage tables)
# 0x700000039 = Caps Lock
# 0x700000029 = Escape

HIDUTIL_ARGS='{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x700000029},{"HIDKeyboardModifierMappingSrc":0x700000029,"HIDKeyboardModifierMappingDst":0x700000039}]}'

apply_now() {
    hidutil property --set "$HIDUTIL_ARGS" > /dev/null
    echo "Caps↔Esc swap applied"
}

install_launchagent() {
    mkdir -p "$(dirname "$PLIST_PATH")"
    cat > "$PLIST_PATH" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.dotfiles.caps-esc</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/hidutil</string>
        <string>property</string>
        <string>--set</string>
        <string>{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x700000029},{"HIDKeyboardModifierMappingSrc":0x700000029,"HIDKeyboardModifierMappingDst":0x700000039}]}</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF
    launchctl load "$PLIST_PATH" 2>/dev/null || true
    echo "LaunchAgent installed - swap persists across reboots"
}

uninstall() {
    launchctl unload "$PLIST_PATH" 2>/dev/null || true
    rm -f "$PLIST_PATH"
    hidutil property --set '{"UserKeyMapping":[]}' > /dev/null
    echo "Caps↔Esc swap removed"
}

status() {
    local current=$(hidutil property --get "UserKeyMapping" 2>/dev/null)
    if echo "$current" | grep -q "0x700000039"; then
        echo "Status: ACTIVE"
        if [ -f "$PLIST_PATH" ]; then
            echo "LaunchAgent: installed (persists across reboots)"
        else
            echo "LaunchAgent: not installed (session only)"
        fi
    else
        echo "Status: INACTIVE"
    fi
}

case "${1:-install}" in
    install)
        apply_now
        install_launchagent
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
