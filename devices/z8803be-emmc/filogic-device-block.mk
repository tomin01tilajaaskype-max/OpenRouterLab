define Device/zbt-z8803be-emmc
DEVICE_VENDOR := ZBTLink
DEVICE_MODEL := Z8803BE
DEVICE_VARIANT := eMMC
DEVICE_DTS := mt7988a-zbtlink-zbt-z8803be-emmc
DEVICE_PACKAGES := 
kmod-mmc 
kmod-sdhci 
kmod-sdhci-mtk 
block-mount 
e2fsprogs 
f2fsck 
mkf2fs
endef
TARGET_DEVICES += zbt-z8803be-emmc
