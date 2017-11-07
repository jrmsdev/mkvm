ISO_MKFS_ARGS := -b isolinux/isolinux.bin


.PHONY: vm-clean
vm-clean:
	rm -vf .vm.*


.PHONY: vm-rootfs
vm-rootfs:
	@echo '>>>'
	@echo '>>> $(VM_ID): vm rootfs'
	@echo '>>>'
