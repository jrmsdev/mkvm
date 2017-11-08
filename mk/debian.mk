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
vm-rootfs: .vm.rootfs


.vm.rootfs:
	@echo '>>>'
	@echo '>>> $(VM_ID): vm rootfs'
	@echo '>>>'
	find $(ROOTFS) -type d -exec chmod u+w {} \;
	find $(ROOTFS) -type f -exec chmod u+w {} \;
	$(MAKE) .vm.preseed .vm.isolinux
	(cd $(ROOTFS) && (rm -f md5sum.txt; \
		find . -follow -type f | sort -u | xargs md5 -r >md5sum.txt))
	@touch .vm.rootfs


.vm.isolinux:
	(preseed_md5=`md5 -r $(ROOTFS)/preseed.cfg`; \
	cat $(FILESDIR)/isolinux.cfg | \
		sed "s#\[PRESEED_MD5\]#$${preseed_md5}#" >$(ROOTFS)/isolinux/isolinux.cfg)


.vm.preseed:
	cat $(FILESDIR)/preseed.cfg | \
		sed 's/\[VM_NAME\]/$(VM_NAME)/' >$(ROOTFS)/preseed.cfg
