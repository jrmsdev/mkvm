# -- workdir / rootfs
WORKDIR := work
ROOTFS := $(WORKDIR)/rootfs
MKVM_TXT := $(ROOTFS)/MKVM.txt

# -- VBox Guest Additions
VBGA_VERSION := 5.2.2
VBGA_URL_BASE := http://deb.debian.org/debian/pool/non-free/v/virtualbox-guest-additions-iso
VBGA_URL := $(VBGA_URL_BASE)/$(VBGA_FILE)
VBGA_FILE := virtualbox-guest-additions-iso_$(VBGA_VERSION).orig.tar.xz
VBGA_ISO := $(WORKDIR)/virtualbox-guest-additions-iso-$(VBGA_VERSION)/VBoxGuestAdditions_$(VBGA_VERSION).iso
