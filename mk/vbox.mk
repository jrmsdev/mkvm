VBOXMAN := VBoxManage
VBOX_OS ?= NOSET_VBOX_OS
VBOX_MEM ?= 512
VBOX_HDD := $(WORKDIR)/vbox/$(VM_ID)/$(VM_ID)-hdd.vhd
VBOX_HDD_MB ?= 16384
VBOX_HDD_FORMAT := VHD

# -- cleanup

.PHONY: vbox-clean
vbox-clean:
	@$(VBOXMAN) unregistervm $(VM_ID) --delete || echo "error ignored: $$?"
	@rm -vf .vbox.*

# -- create vm

.PHONY: vbox-create
vbox-create: .vbox.vm

.vbox.vm: $(VBOX_HDD)
	@echo '>>>'
	@echo '>>> $(VM_ID): vbox $(VM_ID)'
	@echo '>>>'
	$(VBOXMAN) createvm --name $(VM_ID) --ostype $(VBOX_OS) --register \
		--basefolder $(PWD)/$(WORKDIR)/vbox
	$(VBOXMAN) modifyvm $(VM_ID) \
		--memory $(VBOX_MEM) \
		--acpi on \
		--cpu-profile host \
		--cpus 2 \
		--rtcuseutc on \
		--boot1 disk \
		--boot2 dvd \
		--boot3 none \
		--boot4 none \
		--ioapic on \
		--audio none \
		--usb off
	# vm IDE Controller
	$(VBOXMAN) storagectl $(VM_ID) --name 'IDE Controller' \
		--add ide --portcount 2 --bootable on
	# vm hdd
	$(VBOXMAN) storageattach $(VM_ID) --storagectl 'IDE Controller' \
		--port 0 --device 0 --type hdd --medium $(VBOX_HDD)
	@touch .vbox.vm

# -- create vm hdd

$(VBOX_HDD):
	@echo '>>>'
	@echo '>>> $(VM_ID): vbox hdd'
	@echo '>>>'
	$(VBOXMAN) createmedium disk --filename $(VBOX_HDD) \
		--size $(VBOX_HDD_MB) --format $(VBOX_HDD_FORMAT)

# -- vm actions

.PHONY: vbox-install
vbox-install: .vbox.install

.vbox.install: $(ISO_NEW)
	@echo '>>>'
	@echo '>>> $(VM_ID): install'
	@echo '>>>'
	$(VBOXMAN) storageattach $(VM_ID) --storagectl 'IDE Controller' \
		--port 1 --device 0 --type dvddrive --medium $(ISO_NEW)
	$(VBOXMAN) modifyvm $(VM_ID) --boot1 dvd --boot2 disk
	$(VBOXMAN) startvm $(VM_ID) --type gui
	@while pgrep -lfa VirtualBox | grep -v grep | grep -F $(VM_ID) >/dev/null; do \
		echo -n '.'; sleep 1; \
	done; echo 'done!'
	@touch .vbox.install

.PHONY: vbox-start
vbox-start:
	@echo '>>>'
	@echo '>>> $(VM_ID): vbox start'
	@echo '>>>'
	$(VBOXMAN) modifyvm $(VM_ID) --boot1 disk --boot2 dvd
	$(VBOXMAN) startvm $(VM_ID) --type gui
