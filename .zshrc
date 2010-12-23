export BROWSER="google-chrome"
# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

# Set to the name theme to load.
# Look in ~/.oh-my-zsh/themes/
export ZSH_THEME="harrys"

# Set to this to use case-sensitive completion
export CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# export DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# export DISABLE_LS_COLORS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/opt/local/bin:/opt/local/sbin:/usr/local/bin:/usr/local/sbin/:/home/harry/bin/:/opt/local/bin:/opt/local/sbin:/usr/local/bin:/usr/local/sbin/:/home/harry/bin/:/bin:/usr/bin:/sbin:/usr/sbin:/usr/share/java/apache-ant/bin:/usr/bin/perlbin/site:/usr/bin/perlbin/vendor:/usr/bin/perlbin/core

# i need this for aterm
export CC=clang
alias c="clear"
alias cdc="cd; clear"
alias e="emacs -nw"
alias m="mplayer -msglevel all=0 -aspect 16:10 -monitoraspect 16:10 -fs"
