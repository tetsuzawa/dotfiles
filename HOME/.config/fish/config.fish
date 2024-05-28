set -U FZF_LEGACY_KEYBINDINGS 0
set -x LC_ALL en_US.UTF-8


switch (uname)
case Linux
case Darwin
    # for homebrew
    eval "$(/opt/homebrew/bin/brew shellenv)"
case FreeBSD NetBSD DragonFly
case '*'
end


alias cd..="cd .."
# alias rm="rmtrash"
alias ls=eza
alias l="ls"
alias la="ls -a"
alias ll="ls -al"
alias mv="mv -iv"
alias rm="rm -iv"
alias cat=bat
#alias jq=gojq
#
set PATH $PATH $HOME/.local/bin $HOME/local/bin $HOME/go/bin $HOME/.cargo/bin
set GOPATH $HOME/go
#
# set PATH $HOME/.cargo/bin $PATH
# set PATH $PATH $HOME/.symfony/bin

# set PATH $HOME/.cargo/bin $PATH

eval (gh completion -s fish| source)

set -U FZF_LEGACY_KEYBINDINGS 0

# export AWS_PROFILE=zucks-zgok

# set JAVA_HOME /Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home
set LNAG ja_JP.UTF-8

# The next line updates PATH for the Google Cloud SDK.
# bass source '$HOME/google-cloud-sdk/path.bash.inc'

# The next line enables shell command completion for gcloud.
# bass source '$HOME/google-cloud-sdk/completion.bash.inc'

export GPG_TTY=(tty)

# source $HOME/google-cloud-sdk/path.fish.inc



set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH

set -gx JAVA_HOME (/usr/libexec/java_home -v "17")
set -gx PATH "$JAVA_HOME/bin" $PATH


alias snowsql=/Applications/SnowSQL.app/Contents/MacOS/snowsql


set PYENV_ROOT "$HOME/.pyenv"
set PATH "$PYENV_ROOT/bin:$PATH"
# disable pyenv
# eval "$(pyenv init -)"
set PATH "$HOME/.poetry/bin:$PATH"

# jetbrains
set PATH "$HOME/Library/Application Support/JetBrains/Toolbox/scripts:$PATH"
set PATH "/Applications/IntelliJ IDEA.app/Contents/MacOS:$PATH"


alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

export GOPRIVATE=github.com/Levetty
starship init fish | source

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
set --export --prepend PATH "{HOME}/.rd/bin"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
