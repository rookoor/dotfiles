# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Portable macOS/Linux development environment with vim-like navigation system-wide. Replaces heavy tools (Karabiner-Elements) with atomic native implementations (Swift CGEventTap + hidutil).

## Common Commands

```bash
# Full installation (packages + symlinks)
./install.sh

# Modular setup (keys, settings, or configs individually)
./setup.sh all        # Run everything
./setup.sh keys       # Key remapping only (Caps↔Esc, Cmd+HJKL→Arrows)
./setup.sh settings   # System preferences only
./setup.sh configs    # Symlink dotfiles only
./setup.sh status     # Show current configuration status

# Update packages
brew update && brew upgrade
brew bundle --file=~/dotfiles/Brewfile

# Window management services (macOS)
brew services start yabai
brew services start skhd
```

## Architecture

### Key Remapping Stack (macOS)
- **Caps Lock ↔ Escape**: `keys/macos/caps-esc.sh` - uses `hidutil` + LaunchAgent for persistence
- **Cmd+HJKL → Arrows**: `keys/macos/hjkl-arrows.swift` - Swift CGEventTap daemon (requires Accessibility permission)
- Both run as user-level LaunchAgents in `~/Library/LaunchAgents/`

### Config Deployment
All configs are symlinked from this repo to their expected locations:
- `bash/.bashrc` → `~/.bashrc`
- `nvim/` → `~/.config/nvim/`
- `ghostty/config` → `~/.config/ghostty/config`
- etc.

Existing files are backed up to `~/.dotfiles_backup_<timestamp>/` before replacement.

### Neovim Structure
```
nvim/
├── init.lua              # Entry point (lazy.nvim bootstrap)
└── lua/
    ├── config/           # Core: options.lua, keymaps.lua, autocmds.lua
    └── plugins/          # One file per plugin (telescope, lsp, cmp, etc.)
```

## Key Patterns

**Shell scripts**: Use POSIX-compatible bash with color output helpers (`print_success`, `print_error`, etc.). Always detect OS at script start.

**Idempotent setup**: Scripts can run multiple times safely. Check for existing state before modifying.

**Local overrides**: Machine-specific config goes in `~/.bashrc.local` (not tracked).

**Key remapping philosophy**: Prefer native macOS APIs (hidutil, CGEventTap) over third-party tools. Linux uses `keyd`.

## Window Management Shortcuts (yabai/skhd)

- `Alt+HJKL`: Snap windows (left/right/maximize/center)
- `Ctrl+Cmd+H/L`: Switch workspaces
- `Ctrl+Alt+HJKL`: Focus window in direction

## Tmux Prefix

`Ctrl+a` (not default `Ctrl+b`)
