#!/bin/bash
##################################################################################
#
# $Id: .bashrc 23 2016-08-10 15:22 guenter $ 
# 
# Copyright: This Software is released under GPL v2 or newer
#
#################################################################################
#
# Description:	
#
#

# Environment Variables
export PATH=$PATH:$HOME/bin:~/.local/bin

export PS1='\[\033[32m\]$LOGNAME@\h \[\033[33m\w\033[0m\]
$ '
export PS4='(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]}\n'
export TIME="\t%E real,\t%U user,\t%S sys"
export HISTSIZE=50000
export HISTFILESIZE=50000
shopt -s histappend
export HISTIGNORE='*PROMPT_COMMAND=*'
export HISTCONTROL="erasedups"
export HISTTIMEFORMAT=" %Y%m%d-%H%M "
export HH_CONFIG=hicolor

export NO_UNPATCH_BY_DEFAULT=YES
#export GREP_OPTIONS='--color=auto'
alias grep="grep --color=auto"
export TZ='Europe/Berlin'
export EDITOR=vim
export SCREENRC=$HOME/.config/screenrc

# run script hooks in ~/.bashrc.d
run_scripts()
{
    for script in $1/*; do

	# skip non-executable snippets
	[ -x "$script" ] || continue

	# execute $script in the context of the current shell
	. $script
    done
}

[ -d ~/.bashrc.d ] && run_scripts ~/.bashrc.d

# enable bash completion in interactive shells
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi


# GPG-sessions
if [ -f "${HOME}/.gpg-agent-info" ]; then
    . "${HOME}/.gpg-agent-info"
    export GPG_AGENT_INFO
    export SSH_AUTH_SOCK
fi

export GPG_TTY=$(tty)

# ---- language-env DON'T MODIFY THIS LINE!

if [ -d /usr/X11R6/lib/X11/nls ]; then
    XNLSPATH=/usr/X11R6/lib/X11/nls
    export XNLSPATH
fi

# ---- language-env end DON'T MODIFY THIS LINE!

#export LANG=de_DE@euro
export LANG=de_DE.UTF-8
#export LANG=POSIX

# settings
#umask 027

# read ssh aliases
# deprecated in favor of ~/.ssh/config
[ -f ~/bin/sshs ] && {
	. ~/bin/sshs
}

# running on fedora/CentOS?
if [ -f /var/log/syslog ] ; then
    SYSLOG=syslog
else
    SYSLOG=messages
fi

# aliases
# use aptitude instead of apt-get
#[ -x /usr/bin/aptitude ] && {
#    alias apt-get=aptitude
#}

# use apt instead of apt-get
APT=/usr/bin/apt-get
[ -x /usr/bin/apt ] && {
    APT=/usr/bin/apt
    alias apt-get=$APT

}

if [ "$USER" != "root" ] ; then
	alias dpkg="sudo dpkg"
	alias apt="sudo apt"
	alias apt-get="sudo $APT"
	alias apt-mark="sudo apt-mark"
	alias aptitude="sudo aptitude"
	alias dpkg-reconfigure='sudo /usr/sbin/dpkg-reconfigure'
	alias synaptic='sudo /usr/sbin/synaptic'
	alias ping='sudo ping'
	alias traceroute='sudo traceroute'
fi

alias agd="apt-get -d install"
alias agu="apt-get update"
#alias agg="apt-get upgrade"
alias agg="apt full-upgrade"
#alias agg="apt-get  safe-upgrade"
alias aggy="\apt-get -y --force-yes upgrade"
alias agp="apt-get purge"
alias agr="apt-get remove"
alias agar=" sudo \apt-get autoremove"
#alias agar="apt-get autoremove"
alias agc="sudo \apt-get clean"
alias agy='\apt-get -y --force-yes install'
alias ag="echo remember, remember, the faster search; ag "
alias agi='apt-get install'
alias ac='apt-cache search'
alias acs='apt-cache show'
alias ats='debtags show'
alias aps="apt-file find"
alias apu="apt-file update"

# yum
alias yug="yum list | grep -i"
alias yig="yum list installed | grep -i"
alias yc="yum search"
alias yg="yum  install"
alias ygy="yum -y install"
alias yup="yum update -y"
alias rpg="rpm -qa|grep "

# drupal - drush aliases
alias drup="drush updatedb "
alias drue="drush pm-enable "
alias drud="drush pm-disable "
alias drudl="drush pm-download "
alias druun="drush pm-uninstall "
alias druca="drush cache-clear all"
alias drucc="drush cache-clear "

# wordpress
# wp-cli.org
# curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

alias wp="wp-cli.phar --allow-root"

# Ansible
alias ansible_mkd="mkdir -p roles/common/{tasks,handlers,templates,files,vars,defaults,meta}; mkdir library filter_plugins host_vars group_vars"

# LXC
alias lxcls="lxc-ls -f"
alias lslxc="lxc-ls -f"

# LXC-hosts @hansa
alias backit="sudo lxc-start -d -n backit"
alias ba="backit"
alias backit-stop="sudo lxc-stop -n backit"
alias ba-="backit-stop"

alias dev="sudo lxc-start -d -n dev"
alias dev+="sudo lxc-stop -n dev && lxc-start -d -n dev"
alias dev-="sudo lxc-stop -n dev"



# docker specific
alias dio-cclean=dockercleancontainers
alias dio-clean=dockerclean
alias dio="docker"
alias dio-iclean=dockercleanimages
alias dio-ip="docker inspect --format '{{ .NetworkSettings.IPAddress }}' "
alias dio-pid="docker inspect --format '{{ .State.Pid }}' "
alias dio-ps="docker ps"
alias dio-psl='docker ps -l -q'
alias dockercleancontainers="docker ps -a | grep 'Exit'|grep -v rancher-agent-state | awk '{print \$1}' | xargs -L 1 -r docker rm"
alias dockerclean="dockercleancontainers && dockercleanimages"
alias dockercleanimages="docker images -a | grep none | awk '{print \$3}' | xargs -L 1 -r docker rmi"

# Network-related
alias pi8="ping 8.8.8.8"
alias pig="ping gw"

# remember remeber
# htop & glances

# Miscellaneous
alias a=apropos
alias al=alias
alias blkid="blkid|sort"
alias moount="mount"
alias umoount="umount"
alias mountg="mount |egrep"
alias moountg="mountg"
alias mog="mountg"
alias mg="lsmod | egrep "
alias ..="cd ..$1"
alias ...="cd ../..$1"
alias ....="cd ../../..$1"
alias cd..="cd ..$1"
alias chk_md5="md5sum -c md5sums 2> /dev/null | grep OK"
alias del=rm
# df is now a function
alias dfa="/bin/df -h"
#alias df="df -h |grep -v .btrfs"
#[ -x /usr/bin/pydf ] && alias df="pydf |grep -v .btrfs"
[ -x /usr/bin/dcfldd ] && alias dd=dcfldd
alias du="du -shc $*"
alias dir="ls -la"
alias dmt='dmesg | tail -n 20'
alias greo=grep
alias hg="history | fgrep"
alias h=history 
alias isefi='[ -d /sys/firmware/efi ] && echo "EFI boot on HDD" || echo "Legacy boot on HDD"'
alias ketchup='ketchup -w "/usr/bin/wget --limit-rate=200K" -G '
alias less="less -giw"
alias ls="ls --color=auto"
alias la="ls -lah "
alias l=ll
alias ll="ls -lh "
alias md='mkdir -p'
alias mv=/bin/mv
alias most="most -w"
alias ng="netstat -nl | fgrep -i"
alias ngn="netstat -nlp | fgrep -i"
alias .-="popd"
alias +="pushd"
alias rd="rm -rf"
alias rm=/bin/rm
alias rcp=scp
alias screen="screen -DRLOU -h 10000 "
alias sus="sudo su"
alias sshnc="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
alias scpnc='scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
alias sytb="tail --follow=name /var/log/$SYSLOG&"
alias syg="cat /var/log/$SYSLOG|fgrep -i"
alias syl="less -eMQ /var/log/$SYSLOG"
alias syt="tail -n 20 /var/log/$SYSLOG"
alias sytl="tail -n 60 /var/log/$SYSLOG|more"
alias sytll="tail -n 120 /var/log/$SYSLOG|more"

alias jtb="journalctl -f&"
alias jt="journalctl -x -n 20"
alias jtg="journalctl -b -x| grep -B2 -A3 -i"
alias jtl="journalctl -b -x|tail -n 40|most"
alias jtll="journalctl -x|most"

alias time="/usr/bin/time"
alias tf="tail --follow=name "
alias vi=vim
alias wanip='dig +short myip.opendns.com @resolver1.opendns.com'
alias which=whereis
alias w="type -path"



# functions
vp() {
	sudo vi /root/.bashrc
	[ -d /srv/files/linux/skel/Debian/ ] && { 
	    sudo cp /root/.bashrc /srv/files/linux/skel/Debian/root/ 
	}
	[ -d /srv/virt/projects/dei.privat/dotfiles/ ] && {
	    sudo cp /root/.bashrc /srv/virt/projects/dei.privat/dotfiles/
	}
	[ -d ~guenter/ ] && {
	    sudo cp /root/.bashrc ~guenter/
	}
	[ -d ~hikuli/ ] && {
	    sudo cp /root/.bashrc ~hikuli/
	}
       	. ~/.bashrc
} 

mcd() {
    mkdir -p $1
    cd $1
}

df() {
#    du_FS="/ /boot /boot/efi /home /home/guenter/HDD /srv/[f,m]* /srv/virt/* /var/cache/apt-cacher-ng "
    if [ -x /usr/bin/pydf ] ; then
#	if [ `hostname` == hansa ] ; then
#	    pydf $du_FS
#	else
	    pydf $1 |grep -v ".btr"
#	fi
    else
#	if [ `hostname` == hansa ] ; then
#	    /bin/df $du_FS
#	else
	    /bin/df -h $1 |grep -v ".btr"
#	fi
    fi
}

lm() {
        if [ "$#" = 0 ] ; then
                ls -laFh --color=auto | less -eMQ
        elif [ "$#" != 0 ] ; then
                ls -laFh --color=auto "$*" | less -eMQ
        fi
}

ff() {
	find . -name "$1" -ls
}

psg() {
	ps -aef | fgrep -i "$1" | fgrep -v grep
}

psG() {
	ps -eo "%U %u %G %g %p %P %x %C %a" | fgrep -i "$1" | fgrep -v fgrep
}


psm() {
	ps -aef | less -eMQ
}

dmg() {
	dmesg  | fgrep -i "$1" | fgrep -v grep
}

drug() {
	# drupal drush 
	# search modulelist
	if [ "$2" = "" ]; then
		drush pml | fgrep -i $1
	else
		drush pml | egrep -i "$1|$2"
	fi
}

dpg() {
	if [ "$2" = "" ]; then
		dpkg -l | fgrep -i $1
	else
		dpkg -l | egrep -i "$1|$2"
	fi
}


#rpg() {
#	if [ "$2" = "" ]; then
#		rpm -qa | fgrep $1
#	else
#		rpm -qa | egrep "$1|$2"
#	fi
#}

mk_rc() {
	[ -d ~/bin ] || {
		mkdir ~/bin
	}
	pushd ~/bin
	rm -f rc*
	for i in  /etc/init.d/*; do
		ln -s $i .
		mv `basename $i` rc`basename $i`
	done
	popd
}

pst() {
    pstree -ahp `pgrep $1|head -n1` 
}

dpgs() {
    # installed size top 40 
    dpkg-query -W -f='${Installed-Size}\t${PACKAGE}\n' |sort -nr|head -n 40
}

dpsu() {
    # installed size sum
    dpkg-query -W -f='${Installed-Size}\n' |awk '{  sum += $1 }; END { print sum }'
}

apt_swap() {
    if  `ping -q mirror -c 1 >/dev/null` ; then 
	echo mirror reachable
	if [ ! -a /etc/apt/apt.conf.d/02proxy ]; then 
	    echo 'Acquire::http::Proxy "http://mirror:3142";' > /etc/apt/apt.conf.d/.02proxy
	    sudo ln -s /etc/apt/apt.conf.d/.02proxy /etc/apt/apt.conf.d/02proxy && {
	    echo linked 02proxy
	} 
	fi
	apt-get update > /dev/null
    else
	echo mirror unreachable
	sudo rm -f /etc/apt/apt.conf.d/02proxy && {
	    echo unlinked 02proxy
	} 
	apt-get update > /dev/null
    fi
}

ips() {
    #ifconfig |egrep "Adresse|addr" -B1
    ip add list |grep "inet"|sort
    # |egrep -v "inet6|link|valid"| grep "[0-9][0-9][0-9].[0-9][0-9][0-9].[0-9][0-9][0-9].[0-9][0-9][0-9]"
}

function to () {
   if test "$2"; then
     cd "$(apparix "$1" "$2" || echo .)";
   else
     cd "$(apparix "$1" || echo .)";
   fi
   pwd
}
function bm () {
   if test "$2"; then
      apparix --add-mark "$1" "$2";
   elif test "$1"; then
      apparix --add-mark "$1";
   else
      apparix --add-mark;
   fi
}
function portal () {
   if test "$1"; then
      apparix --add-portal "$1";
   else
      apparix --add-portal;
   fi
}
# function to generate list of completions from .apparixrc
function _apparix_aliases ()
{   cur=$2
    dir=$3
    COMPREPLY=()
    if [ "$1" == "$3" ]
    then
        COMPREPLY=( $( cat $HOME/.apparix{rc,expand} | \
                       grep "j,.*$cur.*," | cut -f2 -d, ) )
    else
        dir=`apparix -favour rOl $dir 2>/dev/null` || return 0
        eval_compreply="COMPREPLY=( $(
            cd "$dir"
            \ls -d *$cur* | while read r
            do
                [[ -d "$r" ]] &&
                [[ $r == *$cur* ]] &&
                    echo \"${r// /\\ }\"
            done
            ) )"
        eval $eval_compreply
    fi
    return 0
}

# command to register the above to expand when the 'to' command's args are
# being expanded
complete -F _apparix_aliases to
alias j=to


# add this configuration to ~/.bashrc
#export HH_CONFIG=hicolor         # get more colors
#shopt -s histappend              # append new history items to .bash_history
#export HISTCONTROL=ignorespace   # leading space hides commands from history
#export HISTFILESIZE=10000        # increase history file size (default is 500)
#export HISTSIZE=${HISTFILESIZE}  # increase history size (default is 500)
#export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"   # mem/file sync
#bind '"\C-r": "\C-a hh \C-j"'    # bind hh to Ctrl-r

# prompt gesucht
# http://www.heise.de/ix/heft/Prompt-gesucht-2399784.html

blank() {
      echo $@ | sed 's/[[:blank:]]/%20/g'; 
}

gg() {
     firefox https://www.google.de/search? ⤦
      q=`blank $@`; 
}

