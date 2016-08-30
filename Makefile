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
DOTFILES_GIT_URL	= https://github.com/eb8/dotfiles

# Commands
LINK			= ln -snv
COPY			= cp -fv


# ---- dotfiles ----

GIT = ~/.gitconfig
GIT_OWNER = ~/.gitconfig.$(OWNER)

#MUTT = ~/.muttrc ~/.muttrc.d

VIM = ~/.vimrc

ZSH = ~/.zsh ~/.zshenv ~/.zlogin ~/.zlogout ~/.zshrc

TMUX = ~/.tmux.conf

#XRESOURCES = ~/.Xresources


SYMLINKS = $(VIM) $(ZSH) $(GIT) $(TMUX) $(MUTT) $(XRESOURCES)

OWNER_SYMLINKS = $(GIT_OWNER)


# ---- Main Makefile ----

all: install vim-vundle

#install: git mutt tmux vim zsh mc gpg bin
install: git  tmux vim  gpg bin

owner: install vim-vundle 

#gui: xresources i3 dunst
#	@ansible-playbook -i ansible/inventory ansible/playbooks/gui.yml

#smartcard:
#	@ansible-playbook -i ansible/inventory ansible/playbooks/smartcard.yml

vim: $(VIM)

zsh: $(ZSH)

git: $(GIT) $(GIT_OWNER)

#mutt: $(MUTT) $(MUTT_OWNER)

tmux: $(TMUX)

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
	@mkdir -p ~/.local
	@test -e ~/.local/bin || \
		${LINK} $(CURDIR)/.local/bin ~/.local/bin
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

