ISO_URL ?= NOSET_ISO_URL
ISO_SHA256 ?= NOSET_ISO_SHA256
ISO_XZ ?= false
ISO_ORIG := $(WORKDIR)/orig.iso
ISO_NEW := $(WORKDIR)/$(VM_ID).iso

# -- ISO files

.PHONY: build-installer
build-installer: $(ISO_NEW)

$(ISO_ORIG):
	@echo '>>>'
	@echo '>>> $(VM_ID): fetch iso'
	@echo '>>>'
	mkdir -p $(WORKDIR)
	fetch -r -o $(ISO_ORIG).xz $(ISO_URL)
	$(ISO_XZ) && unxz $(ISO_ORIG).xz

$(ISO_NEW): .rootfs
	@echo '>>>'
	@echo '>>> $(VM_ID): mkisofs'
	@echo '>>>'
	fakeroot mkisofs -quiet -J -R -no-emul-boot -V '$(VM_ID)' -p 'jrmsdev/mkvm' \
		-b boot/cdboot -o $(ISO_NEW) $(ROOTFS)

# -- rootfs

.rootfs: $(ISO_ORIG)
	@echo '>>>'
	@echo '>>> $(VM_ID): iso extract'
	@echo '>>>'
	@sha256 -c $(ISO_SHA256) $(ISO_ORIG)
	rm -rf $(ROOTFS)
	mkdir -p $(ROOTFS)
	tar -C $(ROOTFS) -xf $(ISO_ORIG)
	$(MAKE) vm-rootfs
	@touch .rootfs

$(MKVM_TXT):
	@echo '>>>'
	@echo '>>> $(VM_ID): rootfs info $(MKVM_TXT)'
	@echo '>>>'
	@echo '$(VM_ID)' >$(MKVM_TXT)
	@date -R >>$(MKVM_TXT)
	cat $(MKVM_TXT)
