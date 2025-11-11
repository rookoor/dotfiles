# BetterTouchTool Setup Guide

BetterTouchTool provides system-wide vim-like navigation with Cmd+HJKL.

## Installation

BetterTouchTool is installed via Brewfile. Launch it from Applications after running `install.sh`.

## Required Keybindings

Set up these keyboard shortcuts in BetterTouchTool:

### Basic Navigation (Cmd + H/J/K/L → Arrow Keys)

1. Open BetterTouchTool
2. Go to "Keyboard" tab
3. Click "Add New Shortcut"
4. Add each of these mappings:

| Shortcut | Trigger | Action |
|----------|---------|--------|
| Cmd+H | Keyboard Key | ← (Left Arrow) |
| Cmd+J | Keyboard Key | ↓ (Down Arrow) |
| Cmd+K | Keyboard Key | ↑ (Up Arrow) |
| Cmd+L | Keyboard Key | → (Right Arrow) |

### Word Navigation (Ctrl+Cmd + H/J/K/L → Ctrl+Arrow Keys)

| Shortcut | Trigger | Action |
|----------|---------|--------|
| Ctrl+Cmd+H | Keyboard Key | Ctrl+← (Word Left) |
| Ctrl+Cmd+J | Keyboard Key | Ctrl+↓ (Paragraph Down) |
| Ctrl+Cmd+K | Keyboard Key | Ctrl+↑ (Paragraph Up) |
| Ctrl+Cmd+L | Keyboard Key | Ctrl+→ (Word Right) |

## Step-by-Step Configuration

### 1. Launch BetterTouchTool
```bash
open -a BetterTouchTool
```

### 2. Grant Accessibility Permissions
- Go to System Settings → Privacy & Security → Accessibility
- Enable BetterTouchTool

### 3. Configure Keyboard Shortcuts

#### For Cmd+H → Left Arrow:
1. Click "Keyboard" in the top toolbar
2. Click "+ Add New Shortcut" at the bottom
3. In the "Trigger" column:
   - Click "Record Shortcut"
   - Press: Cmd+H
4. In the "Action" column:
   - Select "Keyboard Keys"
   - Choose "Arrow Left" (←)
5. Click "Save"

#### Repeat for Cmd+J/K/L:
- **Cmd+J**: Arrow Down (↓)
- **Cmd+K**: Arrow Up (↑)
- **Cmd+L**: Arrow Right (→)

#### For Ctrl+Cmd+H → Ctrl+Left Arrow:
1. Click "+ Add New Shortcut"
2. In the "Trigger" column:
   - Click "Record Shortcut"
   - Press: Ctrl+Cmd+H
3. In the "Action" column:
   - Select "Keyboard Keys"
   - Choose "Ctrl+Arrow Left" (Ctrl+←)
4. Click "Save"

#### Repeat for Ctrl+Cmd+J/K/L:
- **Ctrl+Cmd+J**: Ctrl+Arrow Down (Ctrl+↓)
- **Ctrl+Cmd+K**: Ctrl+Arrow Up (Ctrl+↑)
- **Ctrl+Cmd+L**: Ctrl+Arrow Right (Ctrl+→)

### 4. Application Exceptions (Optional)

Some apps like terminals or IDEs may need Cmd+H/K/L for their own shortcuts:

1. Click "App Specific" in BTT
2. Select the app (e.g., Alacritty, Terminal, VS Code)
3. Disable specific shortcuts for that app

Common exceptions:
- **Alacritty/Terminal**: May want native Cmd+K (clear screen)
- **VS Code**: May want native Cmd+K shortcuts
- **Vim/Neovim**: No conflicts (these shortcuts work in GUI vim)

### 5. Test Your Setup

Open any text editor or browser:
- **Cmd+H/J/K/L**: Should move cursor like arrow keys
- **Ctrl+Cmd+H/L**: Should jump by words
- **Alt+H/L**: Should snap windows to left/right (yabai)

## Alternative: Import Configuration

You can also create a BTT preset file and import it:

### Export Your Configuration:
1. In BTT, go to "Presets" → "Export Preset"
2. Save to `~/dotfiles/bettertouchtool/vim-navigation.json`

### Import on New Machine:
1. Open BTT
2. Go to "Presets" → "Import Preset"
3. Select the exported JSON file

## Troubleshooting

### Shortcuts Not Working
- Check System Settings → Privacy & Security → Accessibility
- Ensure BetterTouchTool has permission
- Restart BetterTouchTool

### Conflicts with App Shortcuts
- Add app-specific exceptions in BTT
- Or use different modifier (like Hyper key)

### Cmd+H Hides Windows
- By default, Cmd+H hides the active window on macOS
- BTT should override this, but you may need to:
  1. Go to BTT preferences
  2. Enable "Advanced" → "Override system shortcuts"

## Advanced: Hyper Key Setup (Optional)

For the cleanest setup with zero conflicts, remap Caps Lock to Hyper:

1. Install [Karabiner-Elements](https://karabiner-elements.pqrs.org/)
2. Remap Caps Lock to Hyper (Cmd+Ctrl+Alt+Shift)
3. Use Hyper+H/J/K/L in BTT instead of Cmd+H/J/K/L

This gives you a dedicated modifier key that no app uses.

## Resources

- [BetterTouchTool Docs](https://docs.folivora.ai/)
- [BTT Community Presets](https://community.folivora.ai/c/presets/8)
