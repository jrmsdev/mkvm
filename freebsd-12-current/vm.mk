VM_NAME := freebsd-12-release
VM_VERSION := 0.0

ISO_URL := https://download.freebsd.org/ftp/snapshots/ISO-IMAGES/12.0/FreeBSD-12.0-CURRENT-amd64-20171030-r325156-bootonly.iso.xz

ISO_XZ := true

# checksum of uncompressed file
ISO_SHA256 := 60aab36c97b42c4470fbe69cd140ae7fea629845282f6064fc24b0465241c2e1

# base URL for kernel.txz files and others...
DIST_URL := https://download.freebsd.org/ftp/snapshots/amd64/12.0-CURRENT

VBOX_OS := FreeBSD_64
VBOX_MEM := 512
VBOX_HDD_MB := 10240

include ../mk/vm/freebsd.mk
