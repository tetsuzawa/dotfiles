.PHONY: all help force-symlink-all

all: help

help:
	less Makefile

force-symlink-all: force_symlink_all.sh
	bash $<
