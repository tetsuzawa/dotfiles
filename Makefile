.PHONY: all help force-symlink-all sync-claude install-launchd uninstall-launchd

PLIST_NAME := com.tetsuzawa.dotfiles-sync.plist
LAUNCHD_DIR := $(HOME)/Library/LaunchAgents

all: help

help:
	less Makefile

force-symlink-all: force_symlink_all.sh
	bash $<

sync-claude: sync_claude.sh
	bash $<

install-launchd: $(PLIST_NAME)
	cp $(PLIST_NAME) $(LAUNCHD_DIR)/$(PLIST_NAME)
	launchctl load $(LAUNCHD_DIR)/$(PLIST_NAME)
	@echo "Installed and loaded $(PLIST_NAME)"

uninstall-launchd:
	launchctl unload $(LAUNCHD_DIR)/$(PLIST_NAME) 2>/dev/null || true
	rm -f $(LAUNCHD_DIR)/$(PLIST_NAME)
	@echo "Unloaded and removed $(PLIST_NAME)"
