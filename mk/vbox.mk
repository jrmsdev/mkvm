VBOXMAN := VBoxManage
VBOX_OS ?= NOSET_VBOX_OS
VBOX_VM := mkvm-$(VM_ID)
VBOX_MEM ?= 512
VBOX_HDD := $(WORKDIR)/$(VM_ID)-hdd.vhd
VBOX_HDD_MB ?= 16384
VBOX_HDD_FORMAT := VHD

.PHONY: vbox-distclean
vbox-distclean:
	@echo '>>> $(VM_ID): vbox distclean $(VBOX_VM)'
	$(VBOXMAN) unregistervm $(VBOX_VM) --delete
	@rm -vf .vbox.*

.PHONY: vbox-vm
vbox-vm: .vbox.vm

.vbox.vm: $(VBOX_HDD)
	@echo '>>> $(VM_ID): vbox vm $(VBOX_VM)'
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

$(VBOX_HDD):
	$(VBOXMAN) createmedium disk --filename $(VBOX_HDD) \
		--size $(VBOX_HDD_MB) --format $(VBOX_HDD_FORMAT)
