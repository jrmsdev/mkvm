DIST_URL ?= NOSET_DIST_URL
DISTDIR := $(ROOTFS)/usr/freebsd-dist


.PHONY: build
build:
	@echo '=== $(VM_ID): build'
	@$(MAKE) iso-extract .vm.rootfs .vm.distfiles iso-mkfs


.vm.rootfs:
	@echo '=== $(VM_ID): rootfs'

	echo '/dev/iso9660/$(VM_ID) / cd9660 ro 0 0' >$(WORKDIR)/rootfs/etc/fstab

	cp installerconfig $(WORKDIR)/rootfs/etc/installerconfig

	echo 'autoboot_delay="4"' >>$(WORKDIR)/rootfs/boot/loader.conf

	echo 'hostname="$(VM_NAME)-installer"' >>$(WORKDIR)/rootfs/etc/rc.conf

	cp -vf $(WORKDIR)/dist/MANIFEST $(WORKDIR)/dist/*.txz $(DISTDIR)/

	@sha256 -c $$(grep -F kernel.txz $(DISTDIR)/MANIFEST | awk '{ print $$2 }') $(DISTDIR)/kernel.txz
	@sha256 -c $$(grep -F base.txz $(DISTDIR)/MANIFEST | awk '{ print $$2 }') $(DISTDIR)/base.txz

	@$(MAKE) rootfs-info
	@touch .vm.rootfs


.vm.distfiles:
	mkdir -p $(WORKDIR)/dist
	fetch -r -o $(WORKDIR)/dist/MANIFEST $(DIST_URL)/MANIFEST
	fetch -r -o $(WORKDIR)/dist/kernel.txz $(DIST_URL)/kernel.txz
	fetch -r -o $(WORKDIR)/dist/base.txz $(DIST_URL)/base.txz
	@touch .vm.distfiles
