#!/usr/bin/env bash

# Dotfiles Installation Script
# Semi-automated setup for macOS development environment

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Dotfiles Installation Script${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Function to print colored output
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}→${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}!${NC} $1"
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
        # Detect Linux distro
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            DISTRO=$ID
        fi
    else
        print_error "Unsupported OS: $OSTYPE"
        exit 1
    fi
}

detect_os
print_success "Running on $OS"

# Package installation
install_packages() {
    if [[ "$OS" == "macos" ]]; then
        # Check for Homebrew, install if needed
        print_info "Checking for Homebrew..."
        if ! command -v brew &> /dev/null; then
            print_warning "Homebrew not found. Installing..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

            # Add Homebrew to PATH for Apple Silicon Macs
            if [[ $(uname -m) == 'arm64' ]]; then
                echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.bash_profile
                eval "$(/opt/homebrew/bin/brew shellenv)"
            fi
            print_success "Homebrew installed"
        else
            print_success "Homebrew already installed"
        fi

        # Update Homebrew
        print_info "Updating Homebrew..."
        brew update
        print_success "Homebrew updated"

        # Install packages from Brewfile
        print_info "Installing packages from Brewfile..."
        if [ -f "$DOTFILES_DIR/Brewfile" ]; then
            brew bundle --file="$DOTFILES_DIR/Brewfile"
            print_success "Packages installed"
        else
            print_error "Brewfile not found!"
            exit 1
        fi

    elif [[ "$OS" == "linux" ]]; then
        print_info "Installing packages for Linux ($DISTRO)..."

        # Common packages for all distros
        COMMON_PKGS="git tmux neovim fzf jq htop wget curl"
        BROWSER_PKGS="qutebrowser"

        case "$DISTRO" in
            ubuntu|debian|pop)
                sudo apt update
                sudo apt install -y $COMMON_PKGS $BROWSER_PKGS python3 python3-pip python3-venv
                # Install uv
                curl -LsSf https://astral.sh/uv/install.sh | sh
                ;;
            fedora)
                sudo dnf install -y $COMMON_PKGS $BROWSER_PKGS python3 python3-pip
                curl -LsSf https://astral.sh/uv/install.sh | sh
                ;;
            arch|manjaro)
                sudo pacman -Syu --noconfirm $COMMON_PKGS $BROWSER_PKGS python python-pip uv
                ;;
            *)
                print_warning "Unknown distro: $DISTRO. Install packages manually."
                ;;
        esac

        # Install ghostty on Linux (if available)
        if ! command -v ghostty &> /dev/null; then
            print_warning "Ghostty: Install from https://ghostty.org/download"
        fi

        print_success "Packages installed"
    fi
}

install_packages

# Create symlinks for dotfiles
print_info "Creating symlinks for dotfiles..."

# Backup existing files
backup_dir="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$backup_dir"

# Function to symlink files
symlink_file() {
    local source="$1"
    local target="$2"

    if [ -e "$target" ] || [ -L "$target" ]; then
        print_warning "Backing up existing $target"
        mv "$target" "$backup_dir/"
    fi

    ln -sf "$source" "$target"
    print_success "Linked $target"
}

# Bash
if [ -f "$DOTFILES_DIR/bash/.bashrc" ]; then
    symlink_file "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"
fi

if [ -f "$DOTFILES_DIR/bash/.bash_profile" ]; then
    symlink_file "$DOTFILES_DIR/bash/.bash_profile" "$HOME/.bash_profile"
fi

# Tmux
if [ -f "$DOTFILES_DIR/tmux/.tmux.conf" ]; then
    symlink_file "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
fi

# Ghostty (replaces Alacritty)
if [ -f "$DOTFILES_DIR/ghostty/config" ]; then
    mkdir -p "$HOME/.config/ghostty"
    symlink_file "$DOTFILES_DIR/ghostty/config" "$HOME/.config/ghostty/config"
fi

# Qutebrowser
if [ -f "$DOTFILES_DIR/qutebrowser/config.py" ]; then
    mkdir -p "$HOME/.config/qutebrowser"
    symlink_file "$DOTFILES_DIR/qutebrowser/config.py" "$HOME/.config/qutebrowser/config.py"
fi

# Alacritty (legacy, if still needed)
if [ -f "$DOTFILES_DIR/alacritty/alacritty.toml" ]; then
    mkdir -p "$HOME/.config/alacritty"
    symlink_file "$DOTFILES_DIR/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
fi

# Yabai (macOS only)
if [[ "$OS" == "macos" ]]; then
    if [ -f "$DOTFILES_DIR/yabai/yabairc" ]; then
        mkdir -p "$HOME/.config/yabai"
        symlink_file "$DOTFILES_DIR/yabai/yabairc" "$HOME/.config/yabai/yabairc"
        chmod +x "$HOME/.config/yabai/yabairc"
    fi

    # Skhd
    if [ -f "$DOTFILES_DIR/yabai/skhdrc" ]; then
        mkdir -p "$HOME/.config/skhd"
        symlink_file "$DOTFILES_DIR/yabai/skhdrc" "$HOME/.config/skhd/skhdrc"
    fi
fi

# Neovim
if [ -d "$DOTFILES_DIR/nvim" ]; then
    mkdir -p "$HOME/.config"
    if [ -e "$HOME/.config/nvim" ]; then
        print_warning "Backing up existing nvim config"
        mv "$HOME/.config/nvim" "$backup_dir/"
    fi
    ln -sf "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
    print_success "Linked nvim config"
fi

# Git
if [ -f "$DOTFILES_DIR/git/.gitconfig" ]; then
    symlink_file "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
fi

if [ -f "$DOTFILES_DIR/git/.gitignore_global" ]; then
    symlink_file "$DOTFILES_DIR/git/.gitignore_global" "$HOME/.gitignore_global"
fi

# Karabiner-Elements (macOS only)
if [[ "$OS" == "macos" ]]; then
    if [ -f "$DOTFILES_DIR/karabiner/karabiner.json" ]; then
        mkdir -p "$HOME/.config/karabiner"
        symlink_file "$DOTFILES_DIR/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json"
    fi
fi

print_success "All symlinks created"

# Set bash as default shell if not already
print_info "Checking default shell..."
if [ "$SHELL" != "/bin/bash" ] && [ "$SHELL" != "/opt/homebrew/bin/bash" ]; then
    print_warning "Current shell is $SHELL"
    print_info "To change to bash, run: chsh -s /bin/bash"
else
    print_success "Bash is already your default shell"
fi

# Setup yabai and skhd (macOS only)
if [[ "$OS" == "macos" ]]; then
    print_info "Setting up yabai and skhd..."
    print_warning "Note: yabai requires System Integrity Protection (SIP) to be partially disabled for some features"
    print_info "You can start the services with:"
    echo "  brew services start yabai"
    echo "  brew services start skhd"
fi

# Install Tmux Plugin Manager
print_info "Installing Tmux Plugin Manager (TPM)..."
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    print_success "TPM installed. Press prefix + I in tmux to install plugins"
else
    print_success "TPM already installed"
fi

# Configure macOS defaults (macOS only)
if [[ "$OS" == "macos" ]]; then
    print_info "Configuring macOS preferences..."

    # Configure Scroll Reverser for natural trackpad + traditional mouse scrolling
    if [ -d "/Applications/Scroll Reverser.app" ]; then
        defaults write com.pilotmoon.scroll-reverser ReverseScrolling -bool true
        defaults write com.pilotmoon.scroll-reverser ReverseVertical -bool true
        defaults write com.pilotmoon.scroll-reverser ReverseHorizontal -bool true
        defaults write com.pilotmoon.scroll-reverser ReverseTrackpad -bool false
        defaults write com.pilotmoon.scroll-reverser ReverseMouse -bool true
        defaults write com.pilotmoon.scroll-reverser ReverseTablet -bool false
        defaults write com.pilotmoon.scroll-reverser StartAtLogin -bool true

        # Start Scroll Reverser
        open -a "Scroll Reverser" 2>/dev/null
        print_success "Scroll Reverser configured (trackpad: natural, mouse: traditional)"
    else
        print_warning "Scroll Reverser not found - install via Brewfile"
    fi
fi

# Setup browser-use (AI-assisted browsing)
print_info "Setting up browser-use..."
if [ -f "$DOTFILES_DIR/browser-use/setup.sh" ]; then
    bash "$DOTFILES_DIR/browser-use/setup.sh"
else
    print_warning "browser-use setup script not found"
fi

# Source bash profile
print_info "Sourcing bash profile..."
if [ -f "$HOME/.bash_profile" ]; then
    source "$HOME/.bash_profile"
    print_success "Bash profile sourced"
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Installation Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "  1. Customize git config with your name/email:"
echo "     git config --global user.name \"Your Name\""
echo "     git config --global user.email \"your.email@example.com\""
echo "  2. Open ghostty and test your setup"
echo "  3. Open tmux and press prefix + I to install tmux plugins"
echo "  4. Launch qutebrowser for keyboard-driven browsing"
echo "  5. Add your ANTHROPIC_API_KEY to ~/.browser-use.env for AI browsing"
echo "  6. Restart your terminal or run: source ~/.bash_profile"
if [[ "$OS" == "macos" ]]; then
echo "  7. Start yabai and skhd (macOS):"
echo "     brew services start yabai"
echo "     brew services start skhd"
fi
echo ""
echo -e "${YELLOW}Backup of your old configs:${NC} $backup_dir"
echo ""
