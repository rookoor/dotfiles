# Quick Reference Card

## Vim-Like Universal Navigation + GNOME Window Management

### ⌨️ Keyboard Remapping
```
Caps Lock              → Escape ⭐
Escape                 → Caps Lock
```

### 🎯 Core Navigation (System-Wide)
```
Cmd + H/J/K/L          → Arrow keys (←/↓/↑/→)
Ctrl + Cmd + H/L       → Word navigation (⌥←/⌥→)
Ctrl + Cmd + J/K       → Paragraph navigation
```

### 🪟 Window Snapping (GNOME-Style)
```
Alt + H                → Snap LEFT half
Alt + L                → Snap RIGHT half
Alt + K                → MAXIMIZE
Alt + J                → Center 80%

Alt + U/I/O/P          → Quarters (↖↗↘↙)
Alt + Arrow keys       → Same as HJKL
```

### 🎯 Window Focus
```
Ctrl + Alt + H/J/K/L   → Focus window
Ctrl + Alt + N/P       → Next/Previous window
```

### 🔧 Window Actions
```
Alt + F                → Fullscreen
Alt + T                → Float toggle
Alt + R/Y/X            → Rotate/Mirror
Shift + Alt + B        → Balance windows
```

### 🔄 Layout Modes
```
Ctrl + Alt + D         → Float (GNOME-like) ⭐
Ctrl + Alt + A         → BSP (auto-tiling)
Ctrl + Alt + S         → Stack
```

### 📦 Tmux (Terminal)
```
Ctrl + A, then:
  |                    → Split vertical
  -                    → Split horizontal
  H/J/K/L              → Navigate panes
  Shift+H/J/K/L        → Resize panes
```

### 🚀 Quick Launch
```
Cmd + Return           → Alacritty
```

### 🔄 System Management
```
Shift + Cmd + Alt + R  → Restart yabai
```

---

## Setup Checklist

- [ ] Run `./install.sh` from ~/dotfiles
- [ ] Start yabai: `brew services start yabai`
- [ ] Start skhd: `brew services start skhd`
- [ ] Configure BetterTouchTool (see BETTERTOUCHTOOL_SETUP.md)
- [ ] Open Karabiner-Elements and grant permissions (Caps ↔ Esc)
- [ ] Install Vimium browser extension
- [ ] Open tmux and press `Ctrl+A I` for plugins

---

## Tips

💡 **Caps Lock is now Escape** - perfect for vim! Press where Caps Lock was.
💡 **Default layout is Float** - like GNOME, windows snap manually
💡 **Switch to BSP** with Ctrl+Alt+A for automatic tiling
💡 **Alt+K twice** maximizes then restores window
💡 **Quarter snaps** use U/I/O/P (think of keyboard position)

---

Print this and keep it handy while learning! 📄
