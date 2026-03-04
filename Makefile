.PHONY: all help force-symlink-all sync-claude restore-claude install-launchd uninstall-launchd gen-git-sign-key

PLIST_NAME := com.tetsuzawa.dotfiles-sync.plist
LAUNCHD_DIR := $(HOME)/Library/LaunchAgents
GIT_SIGN_KEY := $(HOME)/.ssh/id_ed25519_git_sign

all: help

help:
	less Makefile

force-symlink-all: force_symlink_all.sh
	bash $<

sync-claude: sync_claude.sh
	bash $<

restore-claude: restore_claude.sh
	bash $<

install-launchd: $(PLIST_NAME)
	sed 's|__HOME__|$(HOME)|g' $(PLIST_NAME) > $(LAUNCHD_DIR)/$(PLIST_NAME)
	launchctl load $(LAUNCHD_DIR)/$(PLIST_NAME)
	@echo "Installed and loaded $(PLIST_NAME)"

uninstall-launchd:
	launchctl unload $(LAUNCHD_DIR)/$(PLIST_NAME) 2>/dev/null || true
	rm -f $(LAUNCHD_DIR)/$(PLIST_NAME)
	@echo "Unloaded and removed $(PLIST_NAME)"

gen-git-sign-key:
	@if [ -f $(GIT_SIGN_KEY) ]; then \
		echo "$(GIT_SIGN_KEY) already exists. Skipping."; \
	else \
		ssh-keygen -t ed25519 -f $(GIT_SIGN_KEY) -C "$$(git config user.email) (git signing key)"; \
		echo ""; \
		echo "Created $(GIT_SIGN_KEY)"; \
		echo "Register the public key as a Signing Key on GitHub:"; \
		echo "  https://github.com/settings/ssh/new"; \
		echo ""; \
		cat $(GIT_SIGN_KEY).pub; \
	fi
