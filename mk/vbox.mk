VBOXMAN := VBoxManage
VBOX_OS ?= NOSET_VBOX_OS
VBOX_VM := mkvm-$(VM_ID)
VBOX_MEM ?= 512
VBOX_HDD := $(WORKDIR)/$(VM_ID)-hdd.vhd
VBOX_HDD_MB ?= 16384
VBOX_HDD_FORMAT := VHD

# -- cleanup

.PHONY: vbox-distclean
vbox-distclean:
	@echo '>>>'
	@echo '>>> $(VM_ID): vbox distclean'
	@echo '>>>'
	$(VBOXMAN) unregistervm $(VBOX_VM) --delete
	@rm -vf .vbox.*

# -- create vm

.PHONY: vbox-vm
vbox-vm: $(VBOX_HDD) .vbox.vm

.vbox.vm:
	@echo '>>>'
	@echo '>>> $(VM_ID): vbox $(VBOX_VM)'
	@echo '>>>'
	$(VBOXMAN) createvm --name $(VBOX_VM) --ostype $(VBOX_OS) --register
	$(VBOXMAN) modifyvm $(VBOX_VM) \
		--memory $(VBOX_MEM) \
		--acpi on \
		--cpu-profile host \
		--cpus 2 \
		--rtcuseutc on \
		--boot1 dvd \
		--boot2 none \
		--boot3 none \
		--boot4 none \
		--ioapic on \
		--audio none \
		--usb off
	# vm IDE Controller
	$(VBOXMAN) storagectl $(VBOX_VM) --name 'IDE Controller' \
		--add ide --portcount 2 --bootable on
	# vm hdd
	$(VBOXMAN) storageattach $(VBOX_VM) --storagectl 'IDE Controller' \
		--port 0 --device 0 --type hdd --medium $(VBOX_HDD)
	@touch .vbox.vm

# -- create vm hdd

$(VBOX_HDD):
	@echo '>>>'
	@echo '>>> $(VM_ID): vbox hdd'
	@echo '>>>'
	$(VBOXMAN) createmedium disk --filename $(VBOX_HDD) \
		--size $(VBOX_HDD_MB) --format $(VBOX_HDD_FORMAT)

# -- install vm

.PHONY: vm-install
vm-install:
	@echo '>>>'
	@echo '>>> $(VM_ID): install'
	@echo '>>>'
	$(VBOXMAN) storageattach $(VBOX_VM) --storagectl 'IDE Controller' \
		--port 1 --device 0 --type dvddrive --medium $(ISO_NEW)
	$(VBOXMAN) startvm $(VBOX_VM) --type gui
