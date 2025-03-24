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

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/tcapelle/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/tcapelle/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/tcapelle/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/tcapelle/google-cloud-sdk/completion.zsh.inc'; fi

if [ -f ~/.tokens ]; then
    source ~/.tokens
fi

# Let's load the source ~/base-venv/bin/activate
if [ -f ~/base-venv/bin/activate ]; then
    source ~/base-venv/bin/activate
fi
