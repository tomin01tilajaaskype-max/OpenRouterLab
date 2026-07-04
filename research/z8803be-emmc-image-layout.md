# ZBT Z8803BE eMMC image layout — research notes

## Confirmed running hardware

- Compatible: `zbtlink,zbt-z8803be,mt7988a-emmc`
- SoC: MediaTek MT7988A
- Storage: eMMC
- eMMC controller: `mmc@11230000`
- Boot root device: `PARTLABEL=rootfs`
- Root filesystem: squashfs + F2FS overlay

## eMMC partition layout seen on the running device

| Partition | Label | Purpose |
|---|---|---|
| mmcblk0p1 | u-boot-env | U-Boot environment |
| mmcblk0p2 | factory | Factory data / MAC addresses / calibration data |
| mmcblk0p3 | fip | Boot firmware package |
| mmcblk0p4 | kernel | Linux kernel |
| mmcblk0p5 | rootfs | SquashFS root filesystem |

## Important safety rules

- Do not overwrite `u-boot-env`, `factory`, or `fip`.
- Do not flash NAND/UBI images to this eMMC device.
- The NAND device tree is only a reference for GPIO, PCIe, Ethernet, LEDs, buttons, fan, and Wi-Fi settings.
- Any future eMMC sysupgrade image must target only the existing `kernel` and `rootfs` partitions.

## Still required before creating a flashable OpenWrt image

1. Inspect a known Z8803BE eMMC firmware image.
2. Identify its kernel and rootfs container format.
3. Confirm how the vendor boot chain loads the `kernel` partition.
4. Create an eMMC-specific image recipe.
5. Test first with recovery access available.
