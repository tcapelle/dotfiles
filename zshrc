# Functions
source ~/.shell/functions.sh

# Allow local customizations in the ~/.shell_local_before file
if [ -f ~/.shell_local_before ]; then
    source ~/.shell_local_before
fi

# Allow local customizations in the ~/.zshrc_local_before file
if [ -f ~/.zshrc_local_before ]; then
    source ~/.zshrc_local_before
fi

# Load Api Keys
if [ -f ~/.secrets.sh ]; then
    source ~/.secrets.sh
fi

# External plugins (initialized before)
source ~/.zsh/plugins_before.zsh

# Settings
source ~/.zsh/settings.zsh

# Bootstrap
source ~/.shell/bootstrap.sh

# External settings
source ~/.shell/external.sh

# Aliases
source ~/.shell/aliases.sh

# Prompt (starship or fallback to custom)
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
else
    source ~/.zsh/prompt.zsh
fi

# External plugins (initialized after)
source ~/.zsh/plugins_after.zsh

# Allow local customizations in the ~/.shell_local_after file
if [ -f ~/.shell_local_after ]; then
    source ~/.shell_local_after
fi

# Allow local customizations in the ~/.zshrc_local_after file
if [ -f ~/.zshrc_local_after ]; then
    source ~/.zshrc_local_after
fi

export CLICOLOR=1

if [ -f ~/.tokens ]; then
    source ~/.tokens
fi

# Load virtual environment - try local .venv first, fallback to base
if [ -f ./.venv/bin/activate ]; then
    source ./.venv/bin/activate
elif [ -f ~/base/bin/activate ]; then
    source ~/base/bin/activate
fi

# Tool-specific configurations (conditional)

# LM Studio CLI
[ -d "$HOME/.lmstudio/bin" ] && export PATH="$PATH:$HOME/.lmstudio/bin"

# Google Cloud SDK
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then
    source "$HOME/google-cloud-sdk/path.zsh.inc"
    source "$HOME/google-cloud-sdk/completion.zsh.inc"
    export GOOGLE_CLOUD_REGION="us-central1"
    export GOOGLE_CLOUD_PROJECT_ID="wandb-growth"
fi

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
