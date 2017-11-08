VAGRANT := vagrant
BOX_PKG := dist/$(VM_ID).box

.PHONY: vagrant-clean
vagrant-clean:
	@rm -vf $(BOX_PKG)

.PHONY: vagrant-box
vagrant-box: $(BOX_PKG)

$(BOX_PKG): .vbox.install
	@echo '>>>'
	@echo '>>> $(VM_ID): vagrant package'
	@echo '>>>'
	mkdir -p dist
	vagrant package --base '$(VM_ID)' --output $(BOX_PKG)
