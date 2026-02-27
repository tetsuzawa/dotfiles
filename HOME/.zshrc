# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"
# The next line updates PATH for the Google Cloud SDK.
#if [ -f '/Users/t-takizawa/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/t-takizawa/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
#if [ -f '/Users/t-takizawa/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/t-takizawa/google-cloud-sdk/completion.zsh.inc'; fi
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/opt/homebrew/opt/php@7.4/bin:$PATH"
export PATH="/opt/homebrew/opt/php@7.4/sbin:$PATH"
export PATH="/opt/homebrew/opt/openssl@3/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/ca01605/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/ca01605/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/ca01605/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/ca01605/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

. "$HOME/.cargo/env"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/taki/.lmstudio/bin"[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

source ~/.safe-chain/scripts/init-posix.sh # Safe-chain Zsh initialization script

# Load custom zsh configuration
source "/Users/taki/.config/zsh/cb-config.zsh"

# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"
