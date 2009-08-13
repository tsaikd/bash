# .bashrc

if [ "${PS1}" ] ; then # this line is used for sftp login

[ "$(type -p distcc)" ] && export PATH="/usr/lib/distcc/bin:${PATH}"
[ "$(type -p ccache)" ] && export PATH="/usr/lib/ccache/bin:${PATH}"

export PATH="${PATH}:${HOME}/script:${HOME}/bin"
export LANG="en_US.UTF-8"
unset LANGUAGE
export LESSHISTFILE="-"
export KD_PUBLIC_PC=1
umask 022
if [ "$(id -u)" -ne 0 ] ; then
	PS1='\[\e[01;31m\]\h \[\e[01;32m\]\u\[\e[01;34;40m\] \w \$ \[\e[m\]'
else
	PS1='\[\e[01;31m\]\h \[\e[01;33;41m\]\u\[\e[01;34;40m\] \w \$ \[\e[m\]'
fi

bind '"\x1b\x5b\x41":history-search-backward' 
bind '"\x1b\x5b\x42":history-search-forward'

[ "$(type -p wget)" ] && function kd_update_bash () {
	local i
	local DIRURL="http://svn.tsaikd.org/gentoo/bash/"
	local FILELIST=".bashrc .bash_logout"

	[ "$(type -p top)" ] && FILELIST="${FILELIST} .toprc"
	[ "$(type -p vi vim)" ] && FILELIST="${FILELIST} .vimrc"
	[ "$(type -p screen)" ] && FILELIST="${FILELIST} .screenrc"

	for i in ${FILELIST} ; do
		wget -q --spider "${DIRURL}${i}" && \
			wget "${DIRURL}${i}" -O "${HOME}/${i}" && \
			chmod 644 "${HOME}/${i}"
	done

	if [ ! -e "${HOME}/.bash_profile" ] ; then
		cd
		ln -s .bashrc .bash_profile
		cd -
	fi
}
[ "$(type -t kd_update_bash)" ] && \
	alias kd_update_bash='kd_update_bash ; source ~/.bashrc'

[ "$(type -p screen)" ] && [ "$TERM" != "screen" ] && function sr() {
	screen -wipe
	{ screen -x `whoami` || screen -S `whoami` ; } && clear
}

[ "$(type -p wget)" ] && function myip () {
	wget "http://www.myipaddress.com/" -qO /dev/stdout | grep -Eo "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+"
}

# $1 : title
# $2 : bbs site url
# $3 : screen number
# $4 : login name (default `whoami`)
[ "$(type -p bbsbot)" ] && [ "${TERM}" == "screen" ] && function fun_bbs_bot () {
	[ $# -lt 3 ] && return 1
	local USERNAME
	[ "$4" ] && USERNAME="$4" || USERNAME="$(whoami)"
	screen -X eval "screen -t \"$1\" $3 /usr/bin/kd_bbsbot.py \"$2\"" "encoding big5 utf8"
#	screen -X eval "screen -t \"$1\" $3 bbsbot $USERNAME \"$2\"" "encoding big5 utf8"
}

alias cd..='cd ..'
alias cp='cp -i'
alias df='df -h -x supermount'
alias du='du -h'
alias fuser='fuser -muv'
alias l='ls --group-directories-first'
alias la='ls -a'
alias l1='ls -1'
alias ll='ls -l'
alias lla='ls -la'
alias lsd='ls -d */'
alias md='mkdir'
alias mv='mv -i'
alias rd='rmdir'
alias rm='rm -i'
alias tar='nice -n 19 tar'
alias telnet='telnet -8'
alias sdiff='sdiff -s -w 80'
alias qq='[ -r "${HOME}/.bash_logout" ] && source "${HOME}/.bash_logout" ; exec clear'

alias sshg='ssh tsaikd@goodguy.csie.ncku.edu.tw'
alias ssht='ssh tsaikd@home.tsaikd.org'
[ "$(type -p rdesktop)" ] && \
	alias rdt='rdesktop home.tsaikd.org $(cat "${HOME}/.rdesktop/password" 2>/dev/null)' && \
	alias rdtsl='rdt -r sound:local -x lan' && \
	alias rdtsr='rdt -r sound:remote'

if [ "$(uname)" == "FreeBSD" ] ; then
	alias ls='ls -FG'
else
	alias ls='ls -F --show-control-chars --color=auto'
fi

[ "$(type -p sudo)" ] && \
	alias ssu='sudo su' && \
	alias su='echo "Please use ssu instead"'
[ "$(type -p perl)" ] && \
	alias col='perl -e "while (<>) { s/\033\[[\d;]*[mH]//g; print; }" | col'
[ "$(type -p reboot)" ] && \
	alias reboot='sync;sync;sync;sync;sync;sync;sleep 1; exec /sbin/reboot'
[ "$(type -p diff)" ] && \
	alias difff='diff -ruNp'
[ "$(type -p colordiff)" ] && \
	alias diff='colordiff'
[ "$(type -p mail)" ] && \
	alias mail='mail -u `\whoami`'
[ "$(type -p svn)" ] && \
	alias sla='svn log -r 1:HEAD'
[ "$(type -p htop)" ] && \
	alias top='htop'
[ "$(type -p mutt)" ] && \
	alias mutt='LANG="zh_TW.utf8" mutt'
[ "$(type -p mkisofs)" ] && \
	alias mkisofs='mkisofs -l -r -J'
[ "$(type -p irssi)" ] && [ "$TERM" == "screen" ] && \
	alias irssi='screen -t IRC 10 irssi'
[ "$(type -p azureus)" ] && [ "$TERM" == "screen" ] && \
	alias bt='screen -X eval "screen -t BT 20 azureus"'
[ "$(type -p cscope)" ] && \
	alias csc='cscope -bR'
[ "$(type -p rdesktop)" ] && \
	alias rdesktop='rdesktop -a 16 -P -f -z'
[ "$(type -p mc)" ] && [ "$TERM" == "screen" ] && \
	alias mc='mc -a'
[ -z "$(type -p host)" ] && [ "$(type -p links)" ] && \
	alias host='links -lookup'
if [ "$(type -p rtorrent)" ] && [ "$TERM" == "screen" ] ; then
	alias btr='screen -X eval "screen -t BT 6 rt"'
	alias btrr='screen -X eval "screen -t BT2 7 rt -r"'
fi
if [ "$(type -t fun_bbs_bot)" ] ; then
	alias bbot_tsaikd='fun_bbs_bot "KD BBS" tsaikd 8'
#	alias bbot_tsaikd='fun_bbs_bot "KD BBS" bbs.tsaikd.twbbs.org 8'
	alias bbot_goodguy='fun_bbs_bot "GoodGuy" goodguy 9'
#	alias bbot_goodguy='fun_bbs_bot "GoodGuy" goodguy.csie.ncku.edu.tw 9'
	alias bbot_dorm='fun_bbs_bot "Dorm" dorm 0'
#	alias bbot_dorm='fun_bbs_bot "Dorm" bbs.ccns.ncku.edu.tw 0'
	alias bbot_bahamut='fun_bbs_bot "BaHa" baha 0'
#	alias bbot_bahamut='fun_bbs_bot "BaHa" bahamut.twbbs.org 0'
	alias bbot_rical='fun_bbs_bot "Rical" rical 0'
#	alias bbot_rical='fun_bbs_bot "Rical" rical.twbbs.org 0'
	alias bbot_qazq='fun_bbs_bot "qazq" qazq 0'
#	alias bbot_qazq='fun_bbs_bot "qazq" qazq.twbbs.org 0'
	alias bbot_ptt='fun_bbs_bot "ptt" ptt 0'
#	alias bbot_ptt='fun_bbs_bot "ptt" ptt.twbbs.org 0'
	alias bbot_fancy='fun_bbs_bot "fancy" fancy 0'
#	alias bbot_fancy='fun_bbs_bot "fancy" fancy.twbbs.org 0'
	alias bbot_moon='fun_bbs_bot "MoonStar" moon 0 Tsaikd'
#	alias bbot_moon='fun_bbs_bot "MoonStar" moonstar.twbbs.org 0 Tsaikd'
fi
if [ "$(type -p emerge)" ] ; then
	alias eei='emerge --info'
fi

# only in gentoo
if [ "$(uname -r | grep "^2\.[46]\.[0-9]\+-gentoo\(-r[0-9]\+\)\?$")" ] ; then
	[ -z "$(type -p dig)" ] && alias dig='echo "Please emerge \"net-dns/bind-tools\" for dig"'
fi

if [ "$(id -u)" -eq 0 ] ; then
	alias cmesg='tail -n 20 /var/log/messages'
	[ -f "/var/log/apache2/access_log" ] && alias capachelog='tail -n 20 /var/log/apache2/access_log'
	alias viconf='vi /root/script/config/general.sh'
	if [ "$(type -p ccache)" ] ; then
		export CCACHE_DIR="/var/tmp/ccache"
		export CCACHE_NOLINK=1
		export CCACHE_UMASK="002"
	fi
	if [ "$(type -p emerge)" ] ; then
		alias ee='emerge -v'
		alias eea='ee -a'
		alias eec='eea -C'
		alias eeC='eea --depclean'
		alias eef='eea -fO'
		alias ee1='eea -1'
		alias eew='eea -uDN world'
		alias eewp='eew -p'
	fi
	if [ "$(type -p eix)" ] ; then
		alias eixx='type -p layman >/dev/null && layman -S ; eix-sync'
	fi
	if [ "$(type -p ntpdate)" ] ; then
		function ntpdate() {
			$(type -P ntpdate) "$@" time.stdtime.gov.tw
			hwclock -w
		}
	fi
	function swapre() {
		swapoff "$@"
		swapon "$@"
	}
	function kd_port_kdbashlib() {
		cd /usr/portage/app-shells
		wget -m -nH --cut-dirs=3 -p -l 2 \
			http://svn.tsaikd.org/gentoo/kdport/app-shells/kdbashlib/
		find -iname "index.htm*" -delete ; cd - >/dev/null
	}
fi

if [ "$(type -p tput)" ] ; then
	[ "$(tput cols)" -lt 80 ] && echo "The screen columns are smaller then 80!"
	[ "$(tput lines)" -lt 24 ] && echo "The screen lines are smaller then 24!"
fi
[ "$(id -u)" -ne 0 ] && [ -n "$(type -p last)" ] && last -5

[ -r "${HOME}/.bashrc.local" ] && source "${HOME}/.bashrc.local"
[ "${TERM}" == "xterm" ] && [ "$(id -u)" -ne 0 ] && [ "$(type -t sr)" ] && sr

fi

