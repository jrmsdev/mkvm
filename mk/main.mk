# -- default target

.PHONY: default
default: build

# -- vars include

include ../mk/vars.mk

# -- main targets

.PHONY: clean
clean:
	@echo '>>>'
	@echo '>>> $(VM_ID): clean'
	@echo '>>>'
	@rm -rf $(WORKDIR)/rootfs/*
	@rm -vrf $(WORKDIR)/rootfs
	@rm -vf $(ISO_NEW) .vm.*

.PHONY: distclean
distclean: clean
	@echo '>>>'
	@echo '>>> $(VM_ID): distclean'
	@echo '>>>'
	@rm -vrf work
	@$(MAKE) vbox-distclean

.PHONY: build
build:
	@$(MAKE) vbox-vm build-installer vm-install

# -- include helpers
include ../mk/installer.mk
include ../mk/vbox.mk
