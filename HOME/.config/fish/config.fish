set -U FZF_LEGACY_KEYBINDINGS 0
set -x LC_ALL en_US.UTF-8

alias cd..="cd .."
# alias rm="rmtrash"
alias ls=exa
alias l="ls"
alias la="ls -a"
alias ll="ls -al"
alias mv="mv -iv"
alias rm="rm -iv"
alias cat=bat
alias jq=gojq
#
# set PATH $HOME/local/bin $HOME/go/bin $PATH
# set GOPATH $HOME/go
#
# set PATH $HOME/.cargo/bin $PATH
# set PATH $PATH $HOME/.symfony/bin

eval (gh completion -s fish| source)

set -U FZF_LEGACY_KEYBINDINGS 0

# export AWS_PROFILE=zucks-zgok

set JAVA_HOME /Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home
set LNAG ja_JP.UTF-8

# The next line updates PATH for the Google Cloud SDK.
# bass source '$HOME/google-cloud-sdk/path.bash.inc'

# The next line enables shell command completion for gcloud.
# bass source '$HOME/google-cloud-sdk/completion.bash.inc'

export GPG_TTY=(tty)

source $HOME/google-cloud-sdk/path.fish.inc
