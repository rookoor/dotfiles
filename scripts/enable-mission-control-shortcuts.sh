#!/usr/bin/env bash

# Enable Mission Control "Move window to space left/right" shortcuts
# These are typically hotkey IDs 118 and 119

set -e

PLIST=~/Library/Preferences/com.apple.symbolichotkeys.plist

echo "Enabling Mission Control window movement shortcuts..."

# Key 118: Move window one space to the left (Ctrl+Shift+Left)
# Parameters: [131330, 123, 8650752]
# - 131330: Ctrl+Shift modifier
# - 123: Left arrow keycode
# - 8650752: Additional flags
/usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:118 dict" "$PLIST" 2>/dev/null || true
/usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:118:enabled bool true" "$PLIST" 2>/dev/null || true
/usr/libexec/PlistBuddy -c "Delete :AppleSymbolicHotKeys:118:value" "$PLIST" 2>/dev/null || true
/usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:118:value dict" "$PLIST"
/usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:118:value:type string standard" "$PLIST"
/usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:118:value:parameters array" "$PLIST"
/usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:118:value:parameters:0 integer 123" "$PLIST"
/usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:118:value:parameters:1 integer 123" "$PLIST"
/usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:118:value:parameters:2 integer 131330" "$PLIST"

# Key 119: Move window one space to the right (Ctrl+Shift+Right)
# Parameters: [131330, 124, 8781824]
# - 131330: Ctrl+Shift modifier
# - 124: Right arrow keycode
# - 8781824: Additional flags
/usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:119 dict" "$PLIST" 2>/dev/null || true
/usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:119:enabled bool true" "$PLIST" 2>/dev/null || true
/usr/libexec/PlistBuddy -c "Delete :AppleSymbolicHotKeys:119:value" "$PLIST" 2>/dev/null || true
/usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:119:value dict" "$PLIST"
/usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:119:value:type string standard" "$PLIST"
/usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:119:value:parameters array" "$PLIST"
/usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:119:value:parameters:0 integer 124" "$PLIST"
/usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:119:value:parameters:1 integer 124" "$PLIST"
/usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:119:value:parameters:2 integer 131330" "$PLIST"

echo "✓ Mission Control shortcuts configured"
echo ""
echo "You need to restart for changes to take effect:"
echo "  killall Dock SystemUIServer"
echo ""
echo "Or log out and back in."
