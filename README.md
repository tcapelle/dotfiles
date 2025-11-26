# Dotfiles

Personal dotfiles managed with [Dotbot](https://github.com/anishathalye/dotbot).

Cross-platform (macOS + Linux compatible).

## Installation

```bash
git clone --recursive https://github.com/tcapelle/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install
```

## What's Included

### Shell (Zsh + Bash)

- **Zsh** as primary shell with modular configuration
- **Bash** with same modern tools (fzf, zoxide, starship)
- **Starship** prompt - fast, customizable, cross-shell
- **zsh-syntax-highlighting** - fish-like syntax highlighting
- **zsh-completions** - additional completion definitions

### Modern CLI Tools

| Tool | Replaces | Description |
|------|----------|-------------|
| [fzf](https://github.com/junegunn/fzf) | - | Fuzzy finder (Ctrl-R history, Ctrl-T files, Alt-C cd) |
| [eza](https://github.com/eza-community/eza) | `ls` | Modern ls with git status and icons |
| [bat](https://github.com/sharkdp/bat) | `cat` | Cat with syntax highlighting |
| [delta](https://github.com/dandavison/delta) | `diff` | Better git diffs (side-by-side, syntax highlighting) |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | `cd` | Smarter cd that learns your habits (`z` command) |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | `grep` | Faster grep |

### Editor (Neovim)

Modern Neovim setup with:
- **lazy.nvim** - fast plugin manager
- **Treesitter** - syntax highlighting
- **Native LSP** - code intelligence (via Mason)
- **Telescope** - fuzzy finder
- **Neo-tree** - file explorer
- **Tokyonight** colorscheme

Pre-configured LSPs: Python (pyright, ruff), TypeScript, Lua, Rust

### Git

- Custom aliases (`gr`, `gra` for graph logs)
- Delta for diffs (side-by-side, syntax highlighting)
- Git LFS support

### Python

- **uv** - fast Python package manager (10-100x faster than pip)
- Enhanced REPL with persistent history and auto-imports
- `mkvenv` helper - create and activate venv in one command

### macOS Only

- **Hammerspoon** - window management and automation
  - AI-powered spellcheck (Cmd+;)
  - Custom hotkeys
- **iTerm2** profile included

### Terminal Multiplexer

- **Tmux** - vi-mode, Ctrl-A prefix

## Structure

```
dotfiles/
├── bash/                 # Bash-specific configs
├── zsh/                  # Zsh-specific configs
│   ├── prompt.zsh        # Fallback prompt (if no starship)
│   ├── settings.zsh      # Zsh settings
│   └── plugins_after.zsh # Tool initializations (fzf, zoxide, uv)
├── shell/                # Shared shell configs
│   ├── aliases.sh        # Common aliases
│   ├── functions.sh      # Utility functions
│   └── external.sh       # Environment variables
├── nvim/                 # Neovim config (Lua)
│   ├── init.lua          # Entry point
│   └── lua/
│       ├── config/       # Core settings
│       └── plugins/      # Plugin specs
├── hammerspoon/          # macOS automation
├── bashrc                # Bash entry point
├── zshrc                 # Zsh entry point
├── gitconfig             # Git configuration
├── tmux.conf             # Tmux configuration
├── starship.toml         # Starship prompt config
└── pythonrc              # Python REPL startup
```

## Key Aliases

```bash
# Navigation
z <dir>          # Smart cd (zoxide)
ll               # eza -lah --git --icons
tree             # eza --tree

# Git
gr               # git log --graph (one line)
gra              # git log --graph --all

# Python
mkvenv [name]    # Create and activate venv (default: .venv)

# Editor
vim, vi          # Aliased to nvim

# General
cat              # bat (syntax highlighted)
```

## Key Bindings

### Shell (fzf)
- `Ctrl-R` - fuzzy search history
- `Ctrl-T` - fuzzy find files
- `Alt-C` - fuzzy cd into directory

### Neovim
- `Space` - leader key
- `<leader>ff` - find files (Telescope)
- `<leader>fg` - live grep
- `<leader>e` - toggle file explorer
- `gd` - go to definition
- `K` - hover documentation
- `<leader>ca` - code actions

### Tmux (prefix: Ctrl-A)
- `prefix + "` - split horizontal
- `prefix + %` - split vertical
- `prefix + h/j/k/l` - navigate panes

## Local Customization

These files are sourced if they exist (not tracked in git):

- `~/.shell_local_before` - runs first
- `~/.shell_local_after` - runs last
- `~/.zshrc_local_before` / `~/.zshrc_local_after`
- `~/.config/nvim/local.lua` - Neovim local config
- `~/.gitconfig_local`
- `~/.tmux_local.conf`
- `~/.secrets.sh` - API keys and tokens

## Dependencies

Install via Homebrew (macOS) or package manager (Linux):

```bash
# macOS
brew install neovim fzf eza bat git-delta zoxide starship uv ripgrep

# Ubuntu/Debian
# See respective tool installation docs
```
