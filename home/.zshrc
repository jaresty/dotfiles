source /usr/share/zsh/share/antigen.zsh

POWERLEVEL9K_MODE='awesome-fontconfig'
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_DELIMITER=""
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs docker_machine)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs time)
POWERLEVEL9K_INSTALLATION_PATH=$ANTIGEN_BUNDLES/bhilburn/powerlevel9k

antigen use oh-my-zsh

COMPLETION_WAITING_DOTS="true"
ZSH_CACHE_DIR=$HOME/.cache/zsh
mkdir -p $ZSH_CACHE_DIR

antigen bundle bundler
antigen bundle compleat
antigen bundle docker
antigen bundle fasd
antigen bundle gpg-agent
antigen bundle gitfast
antigen bundle git-extras
antigen bundle git
antigen bundle systemd
antigen bundle yarn

antigen bundle unixorn/warhol.plugin.zsh

antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting

antigen theme bhilburn/powerlevel9k powerlevel9k

antigen apply

alias vim=nvim

export LANG=en_US.UTF-8

export EDITOR='nvim'
export GIT_EDITOR='nvim'

export GIT_DUET_GLOBAL=true
export GIT_DUET_CO_AUTHORED_BY=true

export PATH=/usr/local/bin:$PATH
export PATH=$HOME/bin:$PATH

export PATH=/usr/local/go/bin:$PATH
export GOPATH=$HOME/workspace
export PATH=$GOPATH/bin:$PATH

# source $HOME/.cargo/env
# export LD_LIBRARY_PATH=$(rustc --print sysroot)/lib

export SSOCA_ENVIRONMENT=bosh
export GODEBUG=netdns=go+2

eval "$(direnv hook zsh)"

export DISPLAY=:0

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source /usr/share/chruby/chruby.sh

if which ruby >/dev/null && which gem >/dev/null; then
  PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

xset r rate 300 35

SSH_ENV="$HOME/.ssh/environment"

function start_agent {
  echo "Initialising new SSH agent..."
  /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
  echo succeeded
  chmod 600 "${SSH_ENV}"
  . "${SSH_ENV}" > /dev/null
  /usr/bin/ssh-add;
}

# Source SSH settings, if applicable

  if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
      start_agent;
    }
else
  start_agent;
fi
