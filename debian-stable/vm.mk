DEBIAN_SUITE := stable
VM_NAME := debian-$(DEBIAN_SUITE)
VM_VERSION := 0.0

ISO_BASE := https://cdimage.debian.org/debian-cd/current/amd64/iso-cd
ISO_URL := $(ISO_BASE)/debian-9.2.1-amd64-netinst.iso

# checksum of uncompressed file
ISO_SHA256 := ec78bc48b48d676775b60eda41528ec33c151c2ce7414a12b13d9b73d34de544

VBOX_OS := Debian_64
VBOX_MEM := 512
VBOX_HDD_MB := 10240

include ../mk/vm/debian.mk
