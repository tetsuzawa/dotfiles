
# The next line updates PATH for the Google Cloud SDK.
#if [ -f '/Users/t-takizawa/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/t-takizawa/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
#if [ -f '/Users/t-takizawa/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/t-takizawa/google-cloud-sdk/completion.zsh.inc'; fi
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/opt/homebrew/opt/php@7.4/bin:$PATH"
export PATH="/opt/homebrew/opt/php@7.4/sbin:$PATH"
export PATH="/opt/homebrew/opt/openssl@3/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '{HOME}/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '{HOME}/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '{HOME}/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '{HOME}/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="{HOME}/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
