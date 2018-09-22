# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi


# setup ssh-agent
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
	echo "Initialising new SSH agent..."
	if [ -x /usr/bin/ssh-agent ] ;then
	    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
	    echo succeeded
	    chmod 600 "${SSH_ENV}"
	    . "${SSH_ENV}" > /dev/null
	    /usr/bin/ssh-add;
	else
	    exit 1
	fi
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



# [ -x /usr/bin/xhost ] && /usr/bin/xhost +
#!/bin/bash

# workaround for keepassxc-snapd-bug
if [ -d ~/snap/keepassxc ]; then
	[ -L ~/snap/keepassxc/current/.local/share/fonts ] || {
	ln -s /snap/keepassxc/current/usr/share/fonts ~/snap/keepassxc/current/.local/share/fonts
	}
fi
