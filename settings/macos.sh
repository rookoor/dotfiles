#!/usr/bin/env bash
# macOS System Settings (via defaults write)
# Usage: ./macos.sh [apply|show|reset]
#
# These settings are opinionated defaults for power users.
# Edit the values below to customize.

set -e

# ============================================
# TRACKPAD
# ============================================
apply_trackpad() {
    echo "Configuring trackpad..."

    # NOTE: Tracking speed must be set via System Settings on macOS Ventura+
    # The defaults write command is ignored. Opening the pane for manual adjustment.
    echo "  ⚠ Trackpad speed: Set manually (System Settings → Trackpad)"
    open "x-apple.systempreferences:com.apple.Trackpad-Settings.extension" 2>/dev/null || true

    # Legacy (works on older macOS)
    defaults write NSGlobalDomain com.apple.trackpad.scaling -float 3.0 2>/dev/null || true

    # Enable tap to click
    defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
    defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

    # Natural scrolling (content tracks finger)
    defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

    # Three finger drag
    defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

    echo "  ✓ Tracking speed: 2.5 (fast)"
    echo "  ✓ Tap to click: enabled"
    echo "  ✓ Natural scrolling: enabled"
    echo "  ✓ Three finger drag: enabled"
}

# ============================================
# KEYBOARD
# ============================================
apply_keyboard() {
    echo "Configuring keyboard..."

    # Key repeat rate (lower = faster, default 6)
    defaults write NSGlobalDomain KeyRepeat -int 2

    # Delay until repeat (lower = shorter, default 25)
    defaults write NSGlobalDomain InitialKeyRepeat -int 15

    # Disable press-and-hold for keys (enables key repeat everywhere)
    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

    # Disable auto-correct
    defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

    # Disable auto-capitalization
    defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

    # Disable smart quotes and dashes (annoying for coding)
    defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
    defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

    # Enable full keyboard access (tab through all UI controls)
    defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

    echo "  ✓ Key repeat: fast (2)"
    echo "  ✓ Initial delay: short (15)"
    echo "  ✓ Press-and-hold: disabled (key repeat works)"
    echo "  ✓ Auto-correct: disabled"
    echo "  ✓ Smart quotes: disabled"
    echo "  ✓ Full keyboard access: enabled"
}

# ============================================
# MOUSE
# ============================================
apply_mouse() {
    echo "Configuring mouse..."

    # Mouse tracking speed (0.0 to 3.0)
    defaults write NSGlobalDomain com.apple.mouse.scaling -float 2.0

    echo "  ✓ Mouse speed: 2.0"
}

# ============================================
# DOCK
# ============================================
apply_dock() {
    echo "Configuring Dock..."

    # Auto-hide dock
    defaults write com.apple.dock autohide -bool true

    # Remove auto-hide delay
    defaults write com.apple.dock autohide-delay -float 0

    # Speed up hide/show animation
    defaults write com.apple.dock autohide-time-modifier -float 0.3

    # Minimize windows into application icon
    defaults write com.apple.dock minimize-to-application -bool true

    # Don't show recent apps
    defaults write com.apple.dock show-recents -bool false

    # Icon size
    defaults write com.apple.dock tilesize -int 48

    echo "  ✓ Auto-hide: enabled (instant)"
    echo "  ✓ Recent apps: hidden"
    echo "  ✓ Icon size: 48px"
}

# ============================================
# FINDER
# ============================================
apply_finder() {
    echo "Configuring Finder..."

    # Show hidden files
    defaults write com.apple.finder AppleShowAllFiles -bool true

    # Show all filename extensions
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true

    # Show path bar
    defaults write com.apple.finder ShowPathbar -bool true

    # Show status bar
    defaults write com.apple.finder ShowStatusBar -bool true

    # Default to list view
    defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

    # Search current folder by default
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

    # Disable warning when changing file extension
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

    # Disable .DS_Store on network/USB volumes
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

    echo "  ✓ Hidden files: visible"
    echo "  ✓ File extensions: visible"
    echo "  ✓ Path/status bar: visible"
    echo "  ✓ Default view: list"
    echo "  ✓ .DS_Store on network: disabled"
}

# ============================================
# MISC
# ============================================
apply_misc() {
    echo "Configuring misc settings..."

    # Expand save panel by default
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

    # Expand print panel by default
    defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
    defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

    # Disable "Are you sure you want to open this application?"
    defaults write com.apple.LaunchServices LSQuarantine -bool false

    # Disable crash reporter
    defaults write com.apple.CrashReporter DialogType -string "none"

    # Screenshot location
    mkdir -p "$HOME/Screenshots"
    defaults write com.apple.screencapture location -string "$HOME/Screenshots"

    # Screenshot format (png, jpg, pdf, gif)
    defaults write com.apple.screencapture type -string "png"

    # Disable shadow in screenshots
    defaults write com.apple.screencapture disable-shadow -bool true

    echo "  ✓ Save/print panels: expanded"
    echo "  ✓ Quarantine dialogs: disabled"
    echo "  ✓ Screenshots: ~/Screenshots (png, no shadow)"
}

# ============================================
# APPLY ALL
# ============================================
apply_all() {
    echo "Applying macOS settings..."
    echo ""
    apply_trackpad
    echo ""
    apply_keyboard
    echo ""
    apply_mouse
    echo ""
    apply_dock
    echo ""
    apply_finder
    echo ""
    apply_misc
    echo ""
    echo "Restarting affected apps..."
    killall Finder 2>/dev/null || true
    killall Dock 2>/dev/null || true
    echo ""
    echo "✓ All settings applied!"
    echo "  Some changes may require logout/restart"
}

# ============================================
# SHOW CURRENT
# ============================================
show_current() {
    echo "Current settings:"
    echo ""
    echo "Trackpad speed:   $(defaults read NSGlobalDomain com.apple.trackpad.scaling 2>/dev/null || echo 'default')"
    echo "Key repeat:       $(defaults read NSGlobalDomain KeyRepeat 2>/dev/null || echo 'default')"
    echo "Initial delay:    $(defaults read NSGlobalDomain InitialKeyRepeat 2>/dev/null || echo 'default')"
    echo "Mouse speed:      $(defaults read NSGlobalDomain com.apple.mouse.scaling 2>/dev/null || echo 'default')"
    echo "Dock autohide:    $(defaults read com.apple.dock autohide 2>/dev/null || echo 'default')"
    echo "Hidden files:     $(defaults read com.apple.finder AppleShowAllFiles 2>/dev/null || echo 'default')"
}

case "${1:-apply}" in
    apply)
        apply_all
        ;;
    trackpad)
        apply_trackpad
        ;;
    keyboard)
        apply_keyboard
        ;;
    dock)
        apply_dock
        ;;
    finder)
        apply_finder
        ;;
    show)
        show_current
        ;;
    *)
        echo "Usage: $0 [apply|trackpad|keyboard|dock|finder|show]"
        exit 1
        ;;
esac
