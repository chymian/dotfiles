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
GIT_OWNER = ~/.gitconfig.$(OWNER)

#MUTT = ~/.muttrc ~/.muttrc.d

VIM = ~/.vimrc

ZSH = ~/.zsh ~/.zshenv ~/.zlogin ~/.zlogout ~/.zshrc

TMUX = ~/.tmux.conf

BASH = ~/.bashrc ~/.profile

BIN = ~/.local/bin

#XRESOURCES = ~/.Xresources


SYMLINKS = $(VIM) $(GIT) $(TMUX) $(BASH) $(BIN)

OWNER_SYMLINKS = $(GIT_OWNER)


# ---- Main Makefile ----

all: install vim-vundle

.PHONY: clean
clean:
	rm -rf $(SYMLINKS)

#install: git mutt tmux vim zsh mc gpg bin
install: clean git tmux vim gpg bash 

#owner: install vim-vundle

#gui: xresources i3 dunst
#	@ansible-playbook -i ansible/inventory ansible/playbooks/gui.yml

#smartcard:
#	@ansible-playbook -i ansible/inventory ansible/playbooks/smartcard.yml

vim: $(VIM)

zsh: $(ZSH)

git: $(GIT) $(GIT_OWNER)

bash: $(BASH)

tmux: $(TMUX)

bin: $(BIN)

xresources: $(XRESOURCES)

vim-vundle:
	@echo "Setting up vim bundles ... "
	@mkdir -p ~/.vim/bundle
	@test -d ~/.vim/bundle/vundle || \
		(git clone --quiet https://github.com/gmarik/vundle.git \
		~/.vim/bundle/vundle && \
		vim +BundleInstall +qall)

mc:
	@mkdir -p ~/.config/mc
	@test -e ~/.config/mc/ini || $(COPY) $(CURDIR)/.config/mc/ini ~/.config/mc/ini

gpg:
	@mkdir -m 700 -p ~/.gnupg
	@test -e ~/.gnupg/gpg.conf || $(LINK) $(CURDIR)/.gnupg/gpg.conf ~/.gnupg/gpg.conf

bin:
	@mkdir -p ~/.local/
#	@test -e ~/.local/bin || \
#		${LINK} $(CURDIR)/bin ~/.local/bin
get:
	@test ! -d ${DOTFILES} && git clone ${DOTFILES_GIT_URL} ${DOTFILES} || true

check-dead:
	find ~ -maxdepth 1 -name '.*' -type l -exec test ! -e {} \; -print

clean-dead:
	find ~ -maxdepth 1 -name '.*' -type l -exec test ! -e {} \; -delete

update:
	@git pull --rebase

$(SYMLINKS):
	@$(LINK) $(CURDIR)/$(patsubst $(HOME)/%,%,$@) $@

$(OWNER_SYMLINKS):
	@test "$(USER)" = "$(OWNER)" && (test -h $@ || $(LINK) $(CURDIR)/$(patsubst $(HOME)/%,%,$@) $@) || true

