VM_NAME := debian-testing
VM_VERSION := 0.0
VM_VERSION_DATE := 2017/12/04

ISO_BASE := https://cdimage.debian.org/cdimage/weekly-builds/amd64/iso-cd
ISO_URL := $(ISO_BASE)/debian-testing-amd64-netinst.iso

# checksum of uncompressed file
ISO_SHA256 := e9c4a8631626d3697600584a9885e92154e547cd4a9b9f9349af9ee3796353e3

VBOX_OS := Debian_64
VBOX_MEM := 512
VBOX_HDD_MB := 10240

include ../mk/debian.mk
