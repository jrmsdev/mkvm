DIST_URL ?= NOSET_DIST_URL
DISTDIR := $(ROOTFS)/usr/freebsd-dist
BSDINSTALL_DISTRIBUTIONS ?= kernel.txz base.txz
ISO_MKFS_ARGS := -b boot/cdboot


.PHONY: vm-clean
vm-clean:
	rm -vf .vm.* installerconfig


.PHONY: vm-rootfs
vm-rootfs: .vm.distfiles
	@echo '>>>'
	@echo '>>> $(VM_ID): vm rootfs'
	@echo '>>>'

	echo '/dev/iso9660/$(VM_ID) / cd9660 ro 0 0' >$(ROOTFS)/etc/fstab

	cp installerconfig $(ROOTFS)/etc/installerconfig

	echo 'autoboot_delay="4"' >>$(ROOTFS)/boot/loader.conf

	echo 'hostname="$(VM_NAME)-installer"' >>$(ROOTFS)/etc/rc.conf

	cp -vf $(WORKDIR)/dist/MANIFEST $(WORKDIR)/dist/*.txz $(DISTDIR)/

	@sha256 -c $$(grep -F kernel.txz $(DISTDIR)/MANIFEST | awk '{ print $$2 }') $(DISTDIR)/kernel.txz
	@sha256 -c $$(grep -F base.txz $(DISTDIR)/MANIFEST | awk '{ print $$2 }') $(DISTDIR)/base.txz


.vm.distfiles: installerconfig
	@echo '>>>'
	@echo '>>> $(VM_ID): vm.distfiles'
	@echo '>>>'
	mkdir -p $(WORKDIR)/dist
	fetch -r -o $(WORKDIR)/dist/MANIFEST $(DIST_URL)/MANIFEST
	@for dn in $(BSDINSTALL_DISTRIBUTIONS); do \
		fetch -r -o $(WORKDIR)/dist/$${dn} $(DIST_URL)/$${dn}; \
	done
	@touch .vm.distfiles


installerconfig: installerconfig.in
	@cat installerconfig.in | \
		sed 's/\[BSDINSTALL_DISTRIBUTIONS\]/$(BSDINSTALL_DISTRIBUTIONS)/' | \
		sed 's/\[VM_ID\]/$(VM_ID)/' >installerconfig
