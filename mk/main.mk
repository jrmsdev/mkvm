# -- default target

.PHONY: default
default: build

# -- vars include
include ../mk/vars.mk

# -- include vm config
include ./vm.mk

# -- vm defaults
VM_NAME ?= NOSET_VM_NAME
VM_VERSION ?= NOSET_VM_VERSION
VM_ID := $(VM_NAME)-v$(VM_VERSION)

# -- main targets

.PHONY: build
build: build-installer vbox-install

.PHONY: clean
clean: vm-clean vagrant-clean
	@rm -vf $(ISO_NEW) .vbox.install

.PHONY: dist
dist: vagrant-box

.PHONY: distclean
distclean: clean vbox-clean
	@echo '>>>'
	@echo '>>> $(VM_ID): distclean'
	@echo '>>>'
	@rm -rf $(WORKDIR)/rootfs/*
	@rm -vrf $(WORKDIR)/rootfs
	@rm -vf .rootfs
	@rm -vrf work dist

# -- include helpers
include ../mk/installer.mk
include ../mk/vbox.mk
include ../mk/vagrant.mk
