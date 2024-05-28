.PHONY: all help force-symlink-all install-brew-packages

all: help

help:
	less Makefile

replace-home: replace_home.sh
	bash $<

force-symlink-all: force_symlink_all.sh
	bash $<

install-brew-packages: /opt/homebrew/bin/brew brew_packages.txt brew_cask_packages.txt
	cat brew_packages.txt | xargs -t brew install
	cat brew_cask_packages.txt | xargs -t brew install --cask



# ------------------------------ deps ------------------------------

/opt/homebrew/bin/brew:
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"