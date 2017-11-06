.PHONY: default
default: build

include ./vm.mk
include ../mk/vars.mk

# -- main targets

.PHONY: clean
clean:
	@echo '=== $(VM_ID): clean'
	@rm -rf $(WORKDIR)/rootfs/*
	@rm -vrf $(WORKDIR)/rootfs
	@rm -vf $(ISO_NEW) .vm.*

.PHONY: distclean
distclean: clean
	@echo '=== $(VM_ID): distclean'
	@rm -vrf work

# -- sub targets for internal use mainly

.PHONY: iso-extract
iso-extract: $(WORKDIR)/rootfs

.PHONY: iso-mkfs
iso-mkfs: $(ISO_NEW)

.PHONY: rootfs-info
rootfs-info: $(ISO_NEW)

# -- ISO files

$(ISO_ORIG):
	@echo '=== $(VM_ID): fetch iso'
	mkdir -p $(WORKDIR)
	fetch -r -o $(ISO_ORIG).xz $(ISO_URL)
	$(ISO_XZ) && unxz $(ISO_ORIG).xz

$(WORKDIR)/rootfs: $(ISO_ORIG)
	@echo '=== $(VM_ID): iso extract'
	@sha256 -c $(ISO_SHA256) $(ISO_ORIG)
	mkdir -p $(WORKDIR)/rootfs
	tar -C $(WORKDIR)/rootfs -xf $(ISO_ORIG)

$(ISO_NEW): $(MKVM_TXT)
	@echo '=== $(VM_ID): mkisofs'
	fakeroot mkisofs -quiet -J -R -no-emul-boot -V '$(VM_ID)' -p 'jrmsdev/mkvm' \
		-b boot/cdboot -o $(ISO_NEW) $(WORKDIR)/rootfs

$(MKVM_TXT): $(WORKDIR)/rootfs
	@echo '=== $(VM_ID): save rootfs info'
	date -R >$(MKVM_TXT)
	cat $(MKVM_TXT)
