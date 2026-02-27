set -gx LC_ALL en_US.UTF-8

# キャッシュ: 外部コマンドの出力をファイルに保存し、config.fish変更時のみ再生成
set -l cache_dir ~/.cache/fish
set -l cache_file $cache_dir/config_cache.fish
set -l config_file (status filename)

if not test -f $cache_file; or test $config_file -nt $cache_file
    mkdir -p $cache_dir

    # brew shellenv
    /opt/homebrew/bin/brew shellenv > $cache_file

    # java_home
    set -l java_home (/usr/libexec/java_home -v "17" 2>/dev/null)
    and echo "set -gx JAVA_HOME $java_home" >> $cache_file

    # completions は ~/.config/fish/completions/ に配置（lazy load）
    gh completion -s fish > ~/.config/fish/completions/gh.fish
    uv generate-shell-completion fish > ~/.config/fish/completions/uv.fish
    # direnv: vendor_conf.d で自動読み込みされるためキャッシュ不要
end

source $cache_file


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
set PATH $PATH $HOME/.local/bin $HOME/local/bin $HOME/go/bin $HOME/.cargo/bin /usr/local/bin
set -gx GOPATH $HOME/go

# fish_git_prompt
set -g __fish_git_prompt_showdirtystate 1
set -g __fish_git_prompt_showuntrackedfiles 1
set -g __fish_git_prompt_showupstream auto
set -g __fish_git_prompt_color_branch green
set -g __fish_git_prompt_color_dirtystate red
set -g __fish_git_prompt_color_untrackedfiles yellow
set -g __fish_git_prompt_char_dirtystate '*'
set -g __fish_git_prompt_char_untrackedfiles '?'
#
# set PATH $HOME/.cargo/bin $PATH
# set PATH $PATH $HOME/.symfony/bin

# set PATH $HOME/.cargo/bin $PATH
set PATH /Applications/Docker.app/Contents/Resources/bin/ $PATH

set -gx LANG ja_JP.UTF-8

set -gx GPG_TTY (tty)

# source $HOME/google-cloud-sdk/path.fish.inc



set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH

# JAVA_HOME はキャッシュから設定済み
set -gx PATH "$JAVA_HOME/bin" $PATH


alias snowsql=/Applications/SnowSQL.app/Contents/MacOS/snowsql


set -gx PYENV_ROOT "$HOME/.pyenv"
fish_add_path "$PYENV_ROOT/bin"
# disable pyenv
# eval "$(pyenv init -)"
fish_add_path "$HOME/.poetry/bin"

# jetbrains
fish_add_path "$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
fish_add_path "/Applications/GoLand.app/Contents/MacOS"

alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

set -gx GOPRIVATE github.com/Levetty

# nodenv
#set PATH "$HOME/.nodenv/shims:$PATH"



# dev dbへport forwardingする
alias ssm-dev="printf '\033]11;#1781d1\007'; printf '\033]10;#ffffff\007'; aws ssm start-session \
      --profile taki-dev \
      --target i-09c55442b44bd63a3 \
          --document-name AWS-StartPortForwardingSessionToRemoteHost \
              --parameters '{\"host\":[\"pg-cloudbase-dev.cluster-c2dld98v374h.ap-northeast-1.rds.amazonaws.com\"],\"portNumber\":[\"5432\"], \"localPortNumber\":[\"15432\"]}'"

# prd dbへport forwardingする（reader）
alias ssm-prd="printf '\033]11;#b81422\007'; printf '\033]10;#ffffff\007'; aws ssm start-session \
          --profile taki-prd \
          --target i-0f25eeee004eb31ee \
                  --document-name AWS-StartPortForwardingSessionToRemoteHost \
                          --parameters '{\"host\":[\"prd-cloudbase-pg-instance-1.ctzb7knvtra9.ap-northeast-1.rds.amazonaws.com\"],\"portNumber\":[\"5432\"], \"localPortNumber\":[\"25432\"]}'"
                        #   --parameters '{\"host\":[\"prd-cloudbase-pg.cluster-ro-ctzb7knvtra9.ap-northeast-1.rds.amazonaws.com\"],\"portNumber\":[\"5432\"], \"localPortNumber\":[\"25432\"]}'"

alias ssm-prd-admin-billable="printf '\033]11;#b81422\007'; printf '\033]10;#ffffff\007'; aws ssm start-session \
          --profile taki-prd \
          --target i-0f25eeee004eb31ee \
                  --document-name AWS-StartPortForwardingSessionToRemoteHost \
                          --parameters '{\"host\":[\"billable-resource-count-index-test.ctzb7knvtra9.ap-northeast-1.rds.amazonaws.com\"],\"portNumber\":[\"5432\"], \"localPortNumber\":[\"22222\"]}'"

alias ssm-prd-kb-admin="aws ssm start-session \
    --profile taki-prd-admin \
      --target i-0f25eeee004eb31ee \
          --document-name AWS-StartPortForwardingSessionToRemoteHost \
              --parameters '{\"host\":[\"cloudbase-knowledge-base.cluster-ctzb7knvtra9.ap-northeast-1.rds.amazonaws.com\"],\"portNumber\":[\"5432\"], \"localPortNumber\":[\"54545\"]}'"

alias ssm-prd-kb-rw="aws ssm start-session \
    --profile taki-prd \
      --target i-0f25eeee004eb31ee \
          --document-name AWS-StartPortForwardingSessionToRemoteHost \
              --parameters '{\"host\":[\"cloudbase-knowledge-base.cluster-ctzb7knvtra9.ap-northeast-1.rds.amazonaws.com\"],\"portNumber\":[\"5432\"], \"localPortNumber\":[\"57545\"]}'"

alias ssm-prd-rw="tmux select-pane -P 'bg=colour52,fg=white'; aws ssm start-session \
          --profile taki-prd \
          --target i-0f25eeee004eb31ee \
                  --document-name AWS-StartPortForwardingSessionToRemoteHost \
                          --parameters '{\"host\":[\"prd-cloudbase-pg.cluster-ctzb7knvtra9.ap-northeast-1.rds.amazonaws.com\"],\"portNumber\":[\"5432\"], \"localPortNumber\":[\"25432\"]}'"

alias ssm-prd-admin-console="aws ssm start-session \
      --profile taki-prd \
      --target i-0f25eeee004eb31ee \
          --document-name AWS-StartPortForwardingSessionToRemoteHost \
              --parameters '{\"host\":[\"cloudbase-admin-console-db.ctzb7knvtra9.ap-northeast-1.rds.amazonaws.com\"],\"portNumber\":[\"5432\"], \"localPortNumber\":[\"45432\"]}'"
# オペコン dev dbへport forwardingする
alias ssm-dev-admin-console="aws ssm start-session \
      --profile taki-dev \
      --target i-09c55442b44bd63a3 \
          --document-name AWS-StartPortForwardingSessionToRemoteHost \
              --parameters '{\"host\":[\"cloudbase-admin-console-db.c2dld98v374h.ap-northeast-1.rds.amazonaws.com\"],\"portNumber\":[\"5432\"], \"localPortNumber\":[\"35432\"]}'"

alias ssm-dev-kb="aws ssm start-session \
      --profile taki-dev \
      --target i-09c55442b44bd63a3\
          --document-name AWS-StartPortForwardingSessionToRemoteHost \
              --parameters '{\"host\":[\"cloudbase-knowledge-base.cluster-ro-c2dld98v374h.ap-northeast-1.rds.amazonaws.com\"],\"portNumber\":[\"5432\"], \"localPortNumber\":[\"65432\"]}'"



alias ssm-sandbox-="aws ssm start-session \
      --profile taki-sandbox \
      --target i-05910065e906148b8 \
          --document-name AWS-StartPortForwardingSessionToRemoteHost \
              --parameters '{\"host\":[\"taki-1.cluster-cuxpb9rji765.ap-northeast-1.rds.amazonaws.com\"],\"portNumber\":[\"5432\"], \"localPortNumber\":[\"45432\"]}'"

alias ssm-sandbox-managed-pg="aws ssm start-session \
      --profile taki-sandbox \
      --target i-05910065e906148b8 \
          --document-name AWS-StartPortForwardingSessionToRemoteHost \
              --parameters '{\"host\":[\"knowledgebasequickcreateaurora-138-auroradbcluster-mexfre5kgpdh.cluster-cuxpb9rji765.ap-northeast-1.rds.amazonaws.com\"],\"portNumber\":[\"5432\"], \"localPortNumber\":[\"55432\"]}'"
            
# dev shinobi dbへport forwardingする
alias ssm-shinobi-dev="printf '\033]11;#1781d1\007'; printf '\033]10;#ffffff\007'; aws ssm start-session \
      --profile dev \
      --target i-09c55442b44bd63a3 \
          --document-name AWS-StartPortForwardingSessionToRemoteHost \
              --parameters '{\"host\":[\"shinobi-dev-db.cluster-c2dld98v374h.ap-northeast-1.rds.amazonaws.com\"],\"portNumber\":[\"5432\"], \"localPortNumber\":[\"35432\"]}'"
              
alias ssm-shinobi-prd="printf '\033]11;#b81422\007'; printf '\033]10;#ffffff\007'; aws ssm start-session \
      --profile prd \
      --target i-0f25eeee004eb31ee \
          --document-name AWS-StartPortForwardingSessionToRemoteHost \
              --parameters '{\"host\":[\"shinobi-prd-db-instance.ctzb7knvtra9.ap-northeast-1.rds.amazonaws.com\"],\"portNumber\":[\"5432\"], \"localPortNumber\":[\"45432\"]}'" 

# dev attackbase db
alias ssm-attackbase-dev="printf '\033]11;#1781d1\007'; printf '\033]10;#ffffff\007'; aws ssm start-session \
      --profile dev \
      --target i-09c55442b44bd63a3 \
          --document-name AWS-StartPortForwardingSessionToRemoteHost \
              --parameters '{\"host\":[\"attackbase-dev-db.cluster-c2dld98v374h.ap-northeast-1.rds.amazonaws.com\"],\"portNumber\":[\"5432\"], \"localPortNumber\":[\"55432\"]}'"


set -x EDITOR vim

# pnpm
set -gx PNPM_HOME "/Users/taki/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/usr/local/bin/google-cloud-sdk/path.fish.inc' ]; . '/usr/local/bin/google-cloud-sdk/path.fish.inc'; end

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/taki/.lmstudio/bin

# Added by Windsurf
fish_add_path /Users/taki/.codeium/windsurf/bin


# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

source ~/.safe-chain/scripts/init-fish.fish # Safe-chain Fish initialization script
