define Device/zbt-z8803be-emmc
  DEVICE_VENDOR := ZBTLink
  DEVICE_MODEL := Z8803BE
  DEVICE_VARIANT := eMMC
  DEVICE_DTS := mt7988a-zbt-z8803be-emmc-vendor-fixed-draft
  DEVICE_DTS_DIR := ../dts
  DEVICE_DTC_FLAGS := --pad 4096

  KERNEL_LOADADDR := 0x48080000
  KERNEL_ENTRY := 0x48080000

  KERNEL := kernel-bin | lzma | fit lzma $$(KDIR)/image-$$(firstword $$(DEVICE_DTS)).dtb
  KERNEL_INITRAMFS := kernel-bin | lzma | fit lzma $$(KDIR)/image-$$(firstword $$(DEVICE_DTS)).dtb with-initrd | pad-to 64k

  IMAGES := sysupgrade.bin
  IMAGE/sysupgrade.bin := sysupgrade-tar | append-metadata

  DEVICE_PACKAGES := \
    kmod-usb3 \
    block-mount \
    f2fsck \
    mkf2fs \
    luci \
    luci-ssl
endef
TARGET_DEVICES += zbt-z8803be-emmc
