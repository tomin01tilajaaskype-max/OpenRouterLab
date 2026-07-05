# Next implementation step

Do not create a flashable image yet.

Confirmed Z8803BE eMMC upgrade behavior:

- Board: zbt-z8803be-emmc
- Compatible: zbtlink,zbt-z8803be,mt7988a-emmc
- Upgrade method: mtk_mmc_do_upgrade_generic
- Kernel target: PARTLABEL=kernel
- Root target: PARTLABEL=rootfs
- Protected partitions:
  - u-boot-env
  - factory
  - fip

Next task:

1. Inspect an existing MT7988 eMMC device definition from the chosen OpenWrt or ImmortalWrt source tree.
2. Identify the exact image pipeline used to generate:
   - kernel
   - root
   - sysupgrade tar metadata
3. Create a Z8803BE eMMC device block based on that existing recipe.
4. Build an image only for structural inspection first.
5. Do not flash until the generated tar contains:
   - CONTROL
   - kernel
   - root
   and the metadata matches zbt-z8803be-emmc.
