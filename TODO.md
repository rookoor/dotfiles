# Future Features

## Interactive Setup Wizard

Create an Arch-style interactive setup experience that walks through configuration steps on a new machine.

**Inspiration:** Arch Linux's guided installers that present options sequentially and let users pick what to configure.

**Modules to include:**
- [ ] SSH multi-account setup (`ssh/setup-github-multi-account.sh`)
- [ ] Homebrew + Brewfile installation
- [ ] Shell configuration (bash/zsh selection)
- [ ] Terminal emulator setup (Ghostty, Alacritty)
- [ ] Key remapping (hjkl-arrows, caps-esc)
- [ ] Git identity configuration
- [ ] Neovim setup

**Implementation ideas:**
- Single entry point script (e.g., `./setup-wizard.sh`)
- Menu-driven with numbered options
- Each module is optional and idempotent
- Progress tracking (what's been configured)
- Could use `gum` or `fzf` for nice TUI selection
