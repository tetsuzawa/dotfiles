#set -U FZF_LEGACY_KEYBINDINGS 0
set -x LC_ALL en_US.UTF-8

alias cd..="cd .."
alias ojt="oj t -c \"go run main.go\""
alias ojtt="g++ main.cpp; oj t"
alias ls=exa
alias la="ls -a"
alias ll="ls -al"
alias cat=bat

set PATH ~/local/bin $PATH

status --is-interactive; and source (rbenv init -|psub)
eval (gh completion -s fish| source)
