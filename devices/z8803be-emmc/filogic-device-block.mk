# ZBT Z8803BE eMMC — experimental boot-format correction
# Replace devices/z8803be-emmc/filogic-device-block.mk with this file.
# Do not flash a new image until its FIT metadata has been inspected.

define Device/zbt-z8803be-emmc
  DEVICE_VENDOR := Zbtlink
  DEVICE_MODEL := ZBT-Z8803BE
  DEVICE_VARIANT := eMMC
  DEVICE_DTS := mt7988a-zbtlink-zbt-z8803be-emmc
  DEVICE_DTS_DIR := ../dts
  DEVICE_DTC_FLAGS := --pad 4096
  DEVICE_PACKAGES := kmod-sfp kmod-hwmon-pwmfan kmod-usb3 kmod-mt7996-firmware mt7988-2p5g-phy-firmware mt7988-wo-firmware f2fsck mkf2fs
  SUPPORTED_DEVICES += zbtlink,zbt-z8803be,mt7988a-emmc

  # Matches the currently working vendor eMMC FIT image.
  KERNEL_LOADADDR := 0x48080000
  KERNEL_ENTRY := 0x48080000
  KERNEL := kernel-bin | lzma | fit lzma $$(KDIR)/image-$$(firstword $$(DEVICE_DTS)).dtb
  KERNEL_INITRAMFS := kernel-bin | lzma | fit lzma $$(KDIR)/image-$$(firstword $$(DEVICE_DTS)).dtb with-initrd | pad-to 64k

  IMAGES := sysupgrade.bin
  IMAGE/sysupgrade.bin := sysupgrade-tar | append-metadata
endef
TARGET_DEVICES += zbt-z8803be-emmc
