VM_NAME := freebsd-11-release
VM_VERSION := 0.0

ISO_URL := https://download.freebsd.org/ftp/releases/ISO-IMAGES/11.1/FreeBSD-11.1-RELEASE-amd64-bootonly.iso.xz

ISO_XZ := true

# checksum of uncompressed file
ISO_SHA256 := ab1539894e74aef77c1c4729fbd2362fc3bd30b71f24db68e1b0307723b72752

# base URL for kernel.txz files and others...
DIST_URL := https://download.freebsd.org/ftp/releases/amd64/11.1-RELEASE

VBOX_OS := FreeBSD_64
VBOX_MEM := 512
VBOX_HDD_MB := 10240

include ../mk/freebsd.mk
