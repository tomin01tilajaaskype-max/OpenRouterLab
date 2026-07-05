# ZBT Z8803BE eMMC
#
# Research-stage device block.
# Uses the verified eMMC DTS and the standard MediaTek eMMC sysupgrade path:
# kernel -> PARTLABEL=kernel
# root   -> PARTLABEL=rootfs

define Device/zbtlink_zbt-z8803be-emmc
  DEVICE_VENDOR := Zbtlink
  DEVICE_MODEL := ZBT-Z8803BE
  DEVICE_VARIANT := eMMC
  DEVICE_DTS := mt7988a-zbtlink-zbt-z8803be-emmc
  DEVICE_DTS_DIR := ../dts
  DEVICE_DTC_FLAGS := --pad 4096

  DEVICE_PACKAGES := \
    kmod-sfp \
    kmod-hwmon-pwmfan \
    kmod-usb3 \
    kmod-mt7996-firmware \
    mt7988-2p5g-phy-firmware \
    mt7988-wo-firmware \
    f2fsck \
    mkf2fs

  SUPPORTED_DEVICES += zbtlink,zbt-z8803be,mt7988a-emmc

  KERNEL := kernel-bin | gzip | \
    fit gzip $$(KDIR)/image-$$(firstword $$(DEVICE_DTS)).dtb

  KERNEL_INITRAMFS := kernel-bin | lzma | \
    fit lzma $$(KDIR)/image-$$(firstword $$(DEVICE_DTS)).dtb with-initrd | pad-to 64k

  IMAGES := sysupgrade.bin
  IMAGE/sysupgrade.bin := sysupgrade-tar | append-metadata
endef

TARGET_DEVICES += zbtlink_zbt-z8803be-emmc
