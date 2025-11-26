# Dotfiles

Personal dotfiles managed with [Dotbot](https://github.com/anishathalye/dotbot).

## Installation

```bash
git clone --recursive https://github.com/tcapelle/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install
```

## What's Included

### Shell (Zsh + Bash)

- **Zsh** as primary shell with modular configuration
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

### Editors

- **Vim** - configured with Solarized theme, plugins via native packages
- **VS Code** - configured as git merge tool

### Git

- Custom aliases (`gr`, `gra` for graph logs)
- Delta for diffs (side-by-side, Solarized theme)
- Git LFS support

### Python

- **uv** - fast Python package manager (10-100x faster than pip)
- Enhanced REPL with persistent history and auto-imports
- `mkvenv` helper - create and activate venv in one command

### macOS

- **Hammerspoon** - window management and automation
  - AI-powered spellcheck (Cmd+;)
  - Custom hotkeys
- **iTerm2** profile included

### Terminal Multiplexer

- **Tmux** - vi-mode, Ctrl-A prefix, Solarized theme

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
├── vim/                  # Vim config and plugins
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

# General
cat              # bat (syntax highlighted)
```

## Key Bindings

### Shell (fzf)
- `Ctrl-R` - fuzzy search history
- `Ctrl-T` - fuzzy find files
- `Alt-C` - fuzzy cd into directory

### Tmux (prefix: Ctrl-A)
- `prefix + |` - split vertical
- `prefix + -` - split horizontal
- `prefix + h/j/k/l` - navigate panes

## Local Customization

These files are sourced if they exist (not tracked in git):

- `~/.shell_local_before` - runs first
- `~/.shell_local_after` - runs last
- `~/.zshrc_local_before` / `~/.zshrc_local_after`
- `~/.vimrc_local`
- `~/.gitconfig_local`
- `~/.tmux_local.conf`
- `~/.secrets.sh` - API keys and tokens

## Dependencies

Install via Homebrew:

```bash
brew install fzf eza bat git-delta zoxide starship uv
```
