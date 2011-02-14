case "$TERM" in
  xterm*|rxvt*)
    preexec () {
	  local EXE=$(echo $1 | cut -d " " -f 1 - )
      print -Pn "\e]0;$EXE\a"  # xterm
    }
    precmd () {
      print -Pn "\e]0;zsh\a"  # xterm
    }
    ;;
  screen*|tmux*)
    preexec () {
      local CMD=${1[(wr)^(*=*|sudo|ssh|-*)]}
	  local EXE=$(echo $1 | cut -d " " -f 1 - )
	  echo -ne "\ek$CMD\e\\"
      print -Pn "\e]0;$EXE\a"  # xterm
    }
    precmd () {
      echo -ne "\ekzsh\e\\"
      print -Pn "\e]0;zsh\a"  # xterm
    }
    ;;
esac
