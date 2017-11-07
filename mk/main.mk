# -- default target

.PHONY: default
default: build

# -- include vm config
include ./vm.mk

# -- vars include
include ../mk/vars.mk

# -- main targets

.PHONY: clean
clean: vm-clean vagrant-clean
	@echo '>>>'
	@echo '>>> $(VM_ID): clean'
	@echo '>>>'
	@rm -vf $(ISO_NEW)

.PHONY: distclean
distclean: clean vbox-clean
	@echo '>>>'
	@echo '>>> $(VM_ID): distclean'
	@echo '>>>'
	@rm -rf $(WORKDIR)/rootfs/*
	@rm -vrf $(WORKDIR)/rootfs
	@rm -vf .rootfs
	@rm -vrf work dist

.PHONY: build
build: vbox-vm build-installer vbox-install

.PHONY: dist
dist: vagrant-box

# -- include helpers
include ../mk/installer.mk
include ../mk/vbox.mk
include ../mk/vagrant.mk
