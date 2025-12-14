#!/usr/bin/env bash
# Browser-Use Setup Script
# Installs browser-use for AI-assisted browsing with Claude

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
VENV_DIR="$HOME/.browser-use"

echo "Setting up browser-use..."

# Check for uv (fast Python package manager)
if ! command -v uv &> /dev/null; then
    echo "Error: uv not found. Install via: brew install uv"
    exit 1
fi

# Create virtual environment
if [ ! -d "$VENV_DIR" ]; then
    echo "Creating virtual environment at $VENV_DIR..."
    uv venv "$VENV_DIR"
fi

# Activate and install
echo "Installing browser-use..."
source "$VENV_DIR/bin/activate"
uv pip install browser-use playwright

# Install browser drivers
echo "Installing Playwright browsers..."
playwright install chromium

# Copy .env template if not exists
if [ ! -f "$HOME/.browser-use.env" ]; then
    if [ -f "$SCRIPT_DIR/.env.template" ]; then
        cp "$SCRIPT_DIR/.env.template" "$HOME/.browser-use.env"
        echo "Created ~/.browser-use.env - add your ANTHROPIC_API_KEY"
    fi
fi

echo ""
echo "Browser-use installed successfully!"
echo ""
echo "To use:"
echo "  1. Add your API key to ~/.browser-use.env"
echo "  2. Run: source ~/.browser-use/bin/activate"
echo "  3. Use browser-use with Claude"
echo ""
