#!/usr/bin/env bash
# Linux System Settings
# Supports: GNOME, KDE Plasma, generic X11
# Usage: ./linux.sh [apply|show]

set -e

detect_de() {
    if [ "$XDG_CURRENT_DESKTOP" = "GNOME" ] || [ "$GNOME_DESKTOP_SESSION_ID" ]; then
        echo "gnome"
    elif [ "$XDG_CURRENT_DESKTOP" = "KDE" ] || [ "$KDE_FULL_SESSION" ]; then
        echo "kde"
    else
        echo "generic"
    fi
}

DE=$(detect_de)

# ============================================
# GNOME Settings (gsettings)
# ============================================
apply_gnome() {
    echo "Applying GNOME settings..."

    # Touchpad
    echo "Configuring touchpad..."
    gsettings set org.gnome.desktop.peripherals.touchpad speed 0.5
    gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
    gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true
    gsettings set org.gnome.desktop.peripherals.touchpad two-finger-scrolling-enabled true
    echo "  ✓ Touchpad speed: 0.5"
    echo "  ✓ Tap to click: enabled"
    echo "  ✓ Natural scroll: enabled"

    # Mouse
    echo "Configuring mouse..."
    gsettings set org.gnome.desktop.peripherals.mouse speed 0.4
    echo "  ✓ Mouse speed: 0.4"

    # Keyboard
    echo "Configuring keyboard..."
    gsettings set org.gnome.desktop.peripherals.keyboard repeat true
    gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 30
    gsettings set org.gnome.desktop.peripherals.keyboard delay 250
    echo "  ✓ Key repeat: fast (30ms interval, 250ms delay)"

    # Interface
    echo "Configuring interface..."
    gsettings set org.gnome.desktop.interface enable-animations true
    gsettings set org.gnome.desktop.interface clock-show-seconds false
    gsettings set org.gnome.desktop.interface show-battery-percentage true
    echo "  ✓ Battery percentage: visible"

    # File manager (Nautilus)
    echo "Configuring file manager..."
    gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'
    gsettings set org.gnome.nautilus.preferences show-hidden-files true
    gsettings set org.gtk.Settings.FileChooser show-hidden true
    echo "  ✓ Hidden files: visible"
    echo "  ✓ Default view: list"

    # Privacy
    echo "Configuring privacy..."
    gsettings set org.gnome.desktop.privacy remember-recent-files false
    echo "  ✓ Recent files: disabled"

    echo ""
    echo "✓ GNOME settings applied"
}

# ============================================
# KDE Plasma Settings (kwriteconfig5)
# ============================================
apply_kde() {
    echo "Applying KDE Plasma settings..."

    # Touchpad (libinput)
    echo "Configuring touchpad..."
    kwriteconfig5 --file kcminputrc --group Libinput --key PointerAcceleration 0.4
    kwriteconfig5 --file kcminputrc --group Libinput --key TapToClick true
    kwriteconfig5 --file kcminputrc --group Libinput --key NaturalScroll true
    echo "  ✓ Touchpad configured"

    # Keyboard
    echo "Configuring keyboard..."
    kwriteconfig5 --file kcminputrc --group Keyboard --key RepeatRate 30
    kwriteconfig5 --file kcminputrc --group Keyboard --key RepeatDelay 250
    echo "  ✓ Key repeat: fast"

    # Dolphin (file manager)
    echo "Configuring Dolphin..."
    kwriteconfig5 --file dolphinrc --group General --key ShowHiddenFiles true
    echo "  ✓ Hidden files: visible"

    # Restart KDE config
    qdbus org.kde.KWin /KWin reconfigure 2>/dev/null || true

    echo ""
    echo "✓ KDE settings applied"
}

# ============================================
# Generic X11 Settings (xinput, xset)
# ============================================
apply_generic() {
    echo "Applying generic X11 settings..."

    # Keyboard repeat rate
    echo "Configuring keyboard..."
    xset r rate 250 30
    echo "  ✓ Key repeat: 250ms delay, 30 cps"

    # Touchpad (if libinput device exists)
    echo ""
    echo "For touchpad settings, edit /etc/X11/xorg.conf.d/40-libinput.conf"
    echo "or use your desktop environment's settings"

    echo ""
    echo "✓ Generic settings applied"
    echo "Note: These settings don't persist. Add 'xset r rate 250 30' to ~/.xinitrc"
}

# ============================================
# Show Current
# ============================================
show_current() {
    echo "Desktop Environment: $DE"
    echo ""

    case "$DE" in
        gnome)
            echo "Touchpad speed:  $(gsettings get org.gnome.desktop.peripherals.touchpad speed)"
            echo "Tap to click:    $(gsettings get org.gnome.desktop.peripherals.touchpad tap-to-click)"
            echo "Key repeat int:  $(gsettings get org.gnome.desktop.peripherals.keyboard repeat-interval)"
            echo "Key repeat del:  $(gsettings get org.gnome.desktop.peripherals.keyboard delay)"
            ;;
        kde)
            echo "Check: systemsettings5"
            ;;
        *)
            echo "Use: xset q | grep 'repeat rate'"
            xset q | grep -A1 "auto repeat"
            ;;
    esac
}

# ============================================
# Main
# ============================================
apply_all() {
    case "$DE" in
        gnome)
            apply_gnome
            ;;
        kde)
            apply_kde
            ;;
        *)
            apply_generic
            ;;
    esac
}

case "${1:-apply}" in
    apply)
        apply_all
        ;;
    show)
        show_current
        ;;
    *)
        echo "Usage: $0 [apply|show]"
        echo "Detected DE: $DE"
        exit 1
        ;;
esac
