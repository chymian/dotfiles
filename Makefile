# Makefile for ~/.config/dotfiles
# Author: guenter hager <guenter@eb8.org>
# kudos to Maciej Delmanowski <drybjed@gmail.com>


# ---- Makefile options ----

# Get current directory
CURDIR			?= $(.CURDIR)

# If current user is the same as owner, do more things
OWNER			= guenter

# Where dotfiles are kept
DOTFILES		= ~/.config/dotfiles

# Source of dotfiles
DOTFILES_GIT_URL	= https://github.com/chymian/dotfiles

# Commands
LINK			= ln -snvf
COPY			= cp -fav


# ---- dotfiles ----

GIT = ~/.gitconfig

#MUTT = ~/.muttrc ~/.muttrc.d

VIM = ~/.vimrc

ZSH = ~/.zsh ~/.zshenv ~/.zlogin ~/.zlogout ~/.zshrc

TMUX = ~/.tmux.conf

BASH = ~/.bashrc ~/.profile

BIN = ~/.local/bin

#XRESOURCES = ~/.Xresources


SYMLINKS = $(VIM) $(TMUX) $(BASH)


# ---- Main Makefile ----

all: install vim-vundle

.PHONY: clean
clean:
	rm -rf $(SYMLINKS)

install: clean git tmux vim gpg bash config

#owner: install vim-vundle

#gui: xresources i3 dunst
#	@ansible-playbook -i ansible/inventory ansible/playbooks/gui.yml

#smartcard:
#	@ansible-playbook -i ansible/inventory ansible/playbooks/smartcard.yml

vim: $(VIM)

zsh: $(ZSH)

bash: $(BASH)

tmux: $(TMUX)

#bin: $(BIN)

xresources: $(XRESOURCES)

vim-vundle:
	@echo "Setting up vim bundles ... "
	@mkdir -p ~/.vim/bundle
	@test -d ~/.vim/bundle/vundle || \
		(git clone --quiet https://github.com/gmarik/vundle.git \
		~/.vim/bundle/vundle && \
		vim +BundleInstall +qall)

config:
	@mkdir -p ~/.config/
	@test -e ~/.config/htop || $(COPY) $(CURDIR)/.config/* ~/.config/

git:
	@test -e $(GIT) || $(COPY) $(CURDIR)/.gitconfig ~/


gpg:
	@mkdir -m 700 -p ~/.gnupg
	@test -e ~/.gnupg/gpg.conf || $(COPY) $(CURDIR)/.gnupg/gpg.conf ~/.gnupg/gpg.conf

bin:
	@mkdir -p ~/.local/
	@test -e ~/.local/bin || \
		${COPY} $(CURDIR)/bin ~/.local/bin
	@test -e ~/.local/bin && \
		${COPY} $(CURDIR)/bin/* ~/.local/bin/

get:
	@test ! -d ${DOTFILES} && git clone ${DOTFILES_GIT_URL} ${DOTFILES} || true

check-dead:
	find ~ -maxdepth 1 -name '.*' -type l -exec test ! -e {} \; -print

clean-dead:
	find ~ -maxdepth 1 -name '.*' -type l -exec test ! -e {} \; -delete

update:
	@git pull --rebase

$(SYMLINKS):
	@$(LINK) ./$(patsubst $(HOME)/%,%,$@) $@
#	@$(LINK) $(CURDIR)/$(patsubst $(HOME)/%,%,$@) $@

