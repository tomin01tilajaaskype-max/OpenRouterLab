# Z8803BE eMMC reference image

Reference image format:

- POSIX tar sysupgrade archive
- Board: zbt-z8803be-emmc
- Kernel: OpenWrt FIT / FDT container
- Root: SquashFS
- Compatible device string:
  zbtlink,zbt-z8803be,mt7988a-emmc

Expected storage layout on the tested eMMC device:

- u-boot-env
- factory
- fip
- kernel
- rootfs

Safety:

- Do not overwrite u-boot-env.
- Do not overwrite factory.
- Do not overwrite fip.
- Future sysupgrade support must update only kernel and rootfs.
