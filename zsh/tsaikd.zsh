#!/bin/zsh

lsopt="-F"
if [[ "$(uname)" == "FreeBSD" ]] ; then
	lsopt="${lsopt} -G"
	alias df='df -T -h'
else
	lshelp="$(ls --help)"
	lsopt="${lsopt} --color=auto"
	[ "$(grep -- "--show-control-chars" <<<"${lshelp}")" ] && \
		lsopt="${lsopt} --show-control-chars"
	[ "$(grep -- "--group-directories-first" <<<"${lshelp}")" ] && \
		lsopt="${lsopt} --group-directories-first"
	alias df='df -T -h -x supermount'
fi
alias l="ls ${lsopt}"
alias la='l -a'
alias l1='l -1'
alias ll='l -l'
alias lla='l -la'
alias lsd='l -d */'
unset lshelp lsopt

alias ssu='sudo su -c "bash --rcfile \"${HOME}/.bashrc\""'

if hash vim 2>/dev/null ; then
	export EDITOR="${EDITOR:-vim}"
fi

if [ "$(type -p screen)" ] && [[ "${TERM}" == "xterm" ]] ; then
	screen -wipe
	{ screen -x `whoami` || screen -S `whoami` ; } && clear
else
	[ "$(id -u)" -ne 0 ] && [ -n "$(type -p last)" ] && last -5
fi

