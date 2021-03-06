VAGRANT := vagrant
BOX_PKG := dist/$(VM_ID).box

.PHONY: vagrant-clean
vagrant-clean:
	@rm -vf $(BOX_PKG)

.PHONY: vagrant-box
vagrant-box: $(BOX_PKG)

$(BOX_PKG):
	@echo '>>>'
	@echo '>>> $(VM_ID): vagrant package'
	@echo '>>>'
	mkdir -p dist
	vagrant package --base '$(VM_ID)' --output $(BOX_PKG)
	@touch $(BOX_PKG)

.PHONY: vagrant-import
vagrant-import: .vbox.import

.vbox.import: $(BOX_PKG)
	@echo '>>>'
	@echo '>>> $(VM_ID): vagrant box add'
	@echo '>>>'
	vagrant box add -cf --name 'jrmsdev/$(VM_NAME)' $(BOX_PKG)
	@touch .vbox.import
