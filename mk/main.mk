# -- default target

.PHONY: default
default: build

# -- vars include

include ../mk/vars.mk

# -- main targets

.PHONY: clean
clean:
	@echo '>>> $(VM_ID): clean'
	@rm -rf $(WORKDIR)/rootfs/*
	@rm -vrf $(WORKDIR)/rootfs
	@rm -vf $(ISO_NEW) .vm.*

.PHONY: distclean
distclean: clean
	@echo '>>> $(VM_ID): distclean'
	@rm -vrf work
	@$(MAKE) vbox-distclean

.PHONY: build
build:
	@$(MAKE) vbox-vm build-installer

# -- include helpers
include ../mk/vbox.mk
include ../mk/installer.mk
