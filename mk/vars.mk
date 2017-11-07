# -- vm defaults
VM_NAME ?= NOSET_VM_NAME
VM_VERSION ?= NOSET_VM_VERSION
VM_ID := $(VM_NAME)-v$(VM_VERSION)

# -- workdir / rootfs
WORKDIR := work
ROOTFS := $(WORKDIR)/rootfs
MKVM_TXT := $(ROOTFS)/MKVM.txt
