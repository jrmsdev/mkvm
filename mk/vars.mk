VM_NAME ?= NOSET_VM_NAME
VM_VERSION ?= NOSET_VM_VERSION
ISO_URL ?= NOSET_ISO_URL
ISO_XZ ?= false
ISO_SHA256 ?= NOSET_ISO_SHA256

VM_ID := $(VM_NAME)-$(VM_VERSION)
WORKDIR := work
ROOTFS := $(WORKDIR)/rootfs
ISO_ORIG := $(WORKDIR)/orig.iso
ISO_NEW := $(WORKDIR)/$(VM_ID).iso
MKVM_TXT := $(ROOTFS)/MKVM.txt
