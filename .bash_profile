# default:cyan / root:red
if [ $UID -eq 0 ]; then
    PS1="\[\033[31m\]\u@\h\[\033[00m\]:\[\033[01m\]\w\[\033[00m\]\\$ "
else
    PS1="\[\033[36m\]\u@\h\[\033[00m\]:\[\033[01m\]\w\[\033[00m\]\\$ "
fi

export HOMEBREW_CASK_OPTS="--appdir=/Applications"
alias ll="ls -alFG"
alias la='ls -AG'
alias l='ls -CFG'
alias ls='ls -FG'

export PATH=$PATH:/usr/local/include

export GOPATH=$HOME/go
export PATH=$PATH:$HOME/go/bin

#aws
complete -C '/usr/local/bin/aws_completer' aws

alias python="python3"
alias pip="pip3"

source "$HOME/.cargo/env"

alias swagger="docker run --rm -it  --user $(id -u):$(id -g) -e GOPATH=$HOME/go:/go -v $HOME:$HOME -w $(pwd) quay.io/goswagger/swagger"

# The next line updates PATH for the Google Cloud SDK.
#if [ -f '/Users/t-takizawa/google-cloud-sdk/path.bash.inc' ]; then . '/Users/t-takizawa/google-cloud-sdk/path.bash.inc'; fi
/Users/t-takizawa/google-cloud-sdk/path.bash.inc

# The next line enables shell command completion for gcloud.
if [ -f '/Users/t-takizawa/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/t-takizawa/google-cloud-sdk/completion.bash.inc'; fi
