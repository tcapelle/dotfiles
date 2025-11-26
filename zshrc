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

# Custom prompt
source ~/.zsh/prompt.zsh

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

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/tcapelle/.lmstudio/bin"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/tcapelle/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/tcapelle/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/tcapelle/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/tcapelle/google-cloud-sdk/completion.zsh.inc'; fi

# Google Cloud SDK
export GOOGLE_CLOUD_REGION="us-central1"
export GOOGLE_CLOUD_PROJECT_ID="wandb-growth"


# Added by Windsurf
export PATH="/Users/tcapelle/.codeium/windsurf/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
