# -------------------------------------------------------
# Automating the installation using preseeding
# http://d-i.alioth.debian.org/manual/en.amd64/apb.html
# -------------------------------------------------------

ISO_MKFS_ARGS := -r -J -no-emul-boot -boot-load-size 4 -boot-info-table
ISO_MKFS_ARGS += -b isolinux/isolinux.bin -c isolinux/boot.cat


.PHONY: vm-clean
vm-clean:
	@rm -vf .vm.* preseed.cfg


.PHONY: vm-rootfs
vm-rootfs: .vm.rootfs


.vm.rootfs:
	@echo '>>>'
	@echo '>>> $(VM_ID): vm rootfs'
	@echo '>>>'
	find $(ROOTFS) -type d -exec chmod u+w {} \;
	find $(ROOTFS) -type f -exec chmod u+w {} \;
	@$(MAKE) .vm.initrd
	@touch .vm.rootfs


.vm.initrd: preseed.cfg
#~ 	rm -rf $(WORKDIR)/initrd
#~ 	mkdir -p $(WORKDIR)/initrd
#~ 	cd $(WORKDIR)/initrd && ( \
#~ 		pax -r -z -f ../rootfs/install.amd/initrd.gz; \
#~ 		cp -v ../preseed.cfg .; \
#~ 		pax -w -z -f ../rootfs/install.amd/initrd.gz .; \
#~ 	)
	cat isolinux.cfg >$(ROOTFS)/isolinux/isolinux.cfg
	cat preseed.cfg >$(ROOTFS)/preseed.cfg
	(cd $(ROOTFS) && (rm -f md5sum.txt; \
		find . -follow -type f | sort -u | xargs md5 -r >md5sum.txt))
	@touch .vm.initrd


preseed.cfg:
	echo '# preseed!!!' >preseed.cfg
