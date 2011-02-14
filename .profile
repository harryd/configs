if [ -e /usr/share/terminfo/x/xterm-256color ]; then
        export TERM='xterm-256color'
else
        export TERM='xterm-color'
fi
if [[ -z $DISPLAY && $(tty) = /dev/tty1 ]]; then
	exec startx
	# Could use xinit instead of startx
	#exec xinit -- /usr/bin/X -nolisten tcp
fi
