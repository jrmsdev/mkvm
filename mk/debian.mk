ISO_MKFS_ARGS := -r -J -no-emul-boot -boot-load-size 4 -boot-info-table
ISO_MKFS_ARGS += -b isolinux/isolinux.bin -c isolinux/boot.cat


.PHONY: vm-clean
vm-clean:
	rm -vf .vm.*


.PHONY: vm-rootfs
vm-rootfs:
	@echo '>>>'
	@echo '>>> $(VM_ID): vm rootfs'
	@echo '>>>'
	find $(ROOTFS) -type d -exec chmod u+w {} \;
	find $(ROOTFS) -type f -exec chmod u+w {} \;
