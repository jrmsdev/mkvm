# -------------------------------------------------------
# Automating the installation using preseeding
# http://d-i.alioth.debian.org/manual/en.amd64/apb.html
# -------------------------------------------------------

ISO_MKFS_ARGS := -r -J -no-emul-boot -boot-load-size 4 -boot-info-table
ISO_MKFS_ARGS += -b isolinux/isolinux.bin -c isolinux/boot.cat
FILESDIR := ../files/debian


.PHONY: vm-clean
vm-clean:
	@rm -vf .vm.*


.PHONY: vm-rootfs
vm-rootfs:  $(VBGA_ISO) .vm.rootfs


# vbox guest additions
$(VBGA_FILE):
	cd $(WORKDIR) && fetch -r -o $(VBGA_FILE) $(VBGA_URL)
	@touch $(VBGA_FILE)

$(VBGA_ISO): $(VBGA_FILE)
	cd $(WORKDIR) && tar -xJf $(VBGA_FILE)
	@touch $(VBGA_ISO)


.vm.rootfs:
	@echo '>>>'
	@echo '>>> $(VM_ID): vm rootfs'
	@echo '>>>'
	find $(ROOTFS) -type d -exec chmod u+w {} \;
	find $(ROOTFS) -type f -exec chmod u+w {} \;
	mkdir -p $(ROOTFS)/mkvm
	cp -a $(VBGA_ISO) $(ROOTFS)/mkvm/vbox-guest-additions.iso
	mkdir -p $(ROOTFS)/mkvm/late_command
	install -m 0755 $(FILESDIR)/late_command/runall $(ROOTFS)/mkvm/late_command
	install -m 0755 $(FILESDIR)/late_command/*-* $(ROOTFS)/mkvm/late_command
	$(MAKE) .vm.preseed .vm.isolinux
	rm -f $(ROOTFS)/md5sum.txt $(ROOTFS)/../rootfs-md5sum.txt
	cd $(ROOTFS) && find . -follow -type f | sort -u | xargs md5 -r >../rootfs-md5sum.txt
	cat $(ROOTFS)/../rootfs-md5sum.txt >$(ROOTFS)/md5sum.txt
	rm -f $(ROOTFS)/../rootfs-md5sum.txt
	@touch .vm.rootfs


.PHONY: .vm.isolinux:
.vm.isolinux:
	(preseed_md5=`md5 -r $(ROOTFS)/preseed.cfg`; \
	cat $(FILESDIR)/isolinux.cfg | \
		sed "s#\[PRESEED_MD5\]#$${preseed_md5}#" >$(ROOTFS)/isolinux/isolinux.cfg)


.PHONY: .vm.preseed:
.vm.preseed:
	cat $(FILESDIR)/preseed.cfg | \
		sed 's/\[DEBIAN_SUITE\]/$(DEBIAN_SUITE)/' | \
		sed 's/\[VM_NAME\]/$(VM_NAME)/' >$(ROOTFS)/preseed.cfg
