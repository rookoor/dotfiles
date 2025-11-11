# Dotfiles

Portable development environment setup for macOS with BetterTouchTool, yabai, alacritty, tmux, and more.

## Features

- **Window Management**: yabai + skhd for tiling window management
- **Terminal**: Alacritty with customized configuration
- **Terminal Multiplexer**: tmux with useful plugins
- **Shell**: Bash with custom configuration and aliases
- **Editor**: Neovim with LSP, autocompletion, and modern plugins
- **Node.js**: NVM for version management
- **Git**: Enhanced git configuration with useful aliases
- **Tools**: gh, git-delta, lazygit, htop, btop, neofetch, and more

## Quick Start

```bash
# Clone this repository
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles

# Run the installation script
cd ~/dotfiles
./install.sh
```

That's it! The script will:
1. Install Homebrew (if needed)
2. Install all packages from Brewfile
3. Symlink all configuration files
4. Set up Tmux Plugin Manager
5. Back up any existing configs

## What Gets Installed

### Package Manager
- **Homebrew**: macOS package manager

### Development Tools
- **git**: Version control
- **node**: JavaScript runtime
- **nvm**: Node version manager
- **neovim**: Modern vim-based editor

### Terminal & Shell
- **alacritty**: GPU-accelerated terminal emulator
- **tmux**: Terminal multiplexer
- **bash**: Unix shell with custom configuration

### Window Management
- **yabai**: Tiling window manager for macOS
- **skhd**: Simple hotkey daemon
- **BetterTouchTool**: Advanced input customization (requires manual setup)

### Git Tools
- **gh**: GitHub CLI
- **git-delta**: Better git diff viewer
- **lazygit**: Simple terminal UI for git
- **tig**: Text-mode interface for git

### System Monitoring
- **htop**: Interactive process viewer
- **btop**: Modern resource monitor
- **neofetch**: System information tool

### CLI Utilities
- **tree**: Directory tree visualization
- **wget**: File downloads
- **jq**: JSON processor
- **fzf**: Fuzzy finder

### Fonts
- **JetBrains Mono Nerd Font**: Terminal font with icons
- **Fira Code Nerd Font**: Alternative monospace font

## Configuration Files

### Bash
- `.bashrc`: Main bash configuration with aliases and functions
- `.bash_profile`: Login shell configuration

### Tmux
- `.tmux.conf`: Tmux configuration with vim-like keybindings

### Alacritty
- `alacritty.toml`: GPU-accelerated terminal configuration

### Yabai & Skhd
- `yabairc`: Window manager configuration
- `skhdrc`: Keyboard shortcuts for window management

### Neovim
- `init.lua`: Main neovim configuration
- `lua/config/`: Core neovim settings
- `lua/plugins/`: Plugin configurations

### Git
- `.gitconfig`: Git configuration with useful aliases
- `.gitignore_global`: Global gitignore patterns

## Manual Setup Steps

After running the installation script:

### 1. Configure Git User Info
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### 2. Set Bash as Default Shell (Optional)
```bash
chsh -s /bin/bash
```

### 3. Start Yabai & Skhd
```bash
brew services start yabai
brew services start skhd
```

Note: yabai requires System Integrity Protection (SIP) to be partially disabled for some features. See [yabai wiki](https://github.com/koekeishiya/yabai/wiki) for details.

### 4. Configure BetterTouchTool
BetterTouchTool is a GUI application that needs to be configured manually. Launch it from Applications and set up your preferences.

### 5. Install Tmux Plugins
```bash
# Open tmux
tmux

# Press prefix + I (Ctrl+a then Shift+i) to install plugins
```

### 6. Setup Node Version Manager
```bash
# Install the latest LTS version of Node
nvm install --lts

# Set it as default
nvm use --lts
nvm alias default node
```

## Keyboard Shortcuts

### Tmux (Prefix: Ctrl+a)
- `Ctrl+a |`: Split pane vertically
- `Ctrl+a -`: Split pane horizontally
- `Ctrl+a h/j/k/l`: Navigate panes (vim-style)
- `Ctrl+a H/J/K/L`: Resize panes
- `Ctrl+a r`: Reload config

### Yabai/Skhd (Window Management)
- `Alt+h/j/k/l`: Focus window in direction
- `Shift+Alt+h/j/k/l`: Swap window in direction
- `Alt+f`: Toggle fullscreen
- `Alt+t`: Toggle float
- `Alt+r`: Rotate tree
- `Shift+Alt+b`: Balance windows
- `Cmd+Return`: Open Alacritty

### Neovim (Leader: Space)
- `<leader>ff`: Find files
- `<leader>fs`: Find string (grep)
- `<leader>fb`: Find buffers
- `<leader>w`: Save file
- `<leader>q`: Quit
- `gd`: Go to definition
- `K`: Show documentation
- `<leader>ca`: Code actions

## Customization

### Local Bash Configuration
Create `~/.bashrc.local` for machine-specific bash configuration that won't be tracked in git.

### Adding More Packages
Edit `Brewfile` and run:
```bash
brew bundle --file=~/dotfiles/Brewfile
```

### Updating Packages
```bash
brew update
brew upgrade
```

## File Structure

```
~/dotfiles/
├── install.sh              # Main installation script
├── Brewfile                # Homebrew packages
├── README.md               # This file
├── bash/
│   ├── .bashrc            # Bash configuration
│   └── .bash_profile      # Bash login shell
├── tmux/
│   └── .tmux.conf         # Tmux configuration
├── alacritty/
│   └── alacritty.toml     # Alacritty configuration
├── yabai/
│   ├── yabairc            # Yabai configuration
│   └── skhdrc             # Skhd keybindings
├── nvim/
│   ├── init.lua           # Neovim entry point
│   ├── lua/config/        # Core configuration
│   └── lua/plugins/       # Plugin configurations
└── git/
    ├── .gitconfig         # Git configuration
    └── .gitignore_global  # Global gitignore
```

## Troubleshooting

### Homebrew Not Found
If you get a "brew: command not found" error, add Homebrew to your PATH:
```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### Yabai Not Working
1. Grant accessibility permissions: System Settings → Privacy & Security → Accessibility
2. Check if yabai is running: `brew services list`
3. View logs: `tail -f /opt/homebrew/var/log/yabai/yabai.err.log`

### Neovim LSP Not Working
1. Open Neovim
2. Run `:checkhealth` to diagnose issues
3. Install language servers: `:Mason`

### Tmux Plugins Not Installing
1. Make sure TPM is installed: `ls ~/.tmux/plugins/tpm`
2. Open tmux and press `Ctrl+a I` (capital I)

## Backup

Your original configuration files are automatically backed up to `~/.dotfiles_backup_[timestamp]` before any changes are made.

## Updating Dotfiles

```bash
cd ~/dotfiles
git pull origin main
./install.sh
```

## Contributing

Feel free to fork this repository and customize it for your own use!

## Resources

- [yabai](https://github.com/koekeishiya/yabai)
- [skhd](https://github.com/koekeishiya/skhd)
- [tmux](https://github.com/tmux/tmux)
- [Neovim](https://neovim.io/)
- [Alacritty](https://alacritty.org/)
- [BetterTouchTool](https://folivora.ai/)

## License

MIT
