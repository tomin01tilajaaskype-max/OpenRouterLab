#!/usr/bin/env python3
from pathlib import Path
p=Path('openwrt/target/linux/mediatek/filogic/base-files/lib/upgrade/platform.sh')
s=p.read_text()
board='zbtlink,zbt-z8803be,mt7988a-emmc'
if board in s: raise SystemExit('Refusing duplicate eMMC board upgrade rules')

def add_case(function, arm, default=True):
    global s
    start=s.index(function+'() {')
    end=s.index('\n}',start)
    body=s[start:end]
    if default:
        idx=body.rfind('\n\t*)')
    else:
        idx=body.rfind('\n\tesac')
    if idx<0:raise SystemExit('Missing case anchor in '+function)
    s=s[:start+idx]+'\n'+arm+s[start+idx:]

add_case('platform_do_upgrade', '''\tzbtlink,zbt-z8803be,mt7988a-emmc)
\t\tCI_KERNPART="kernel"
\t\tCI_ROOTPART="rootfs"
\t\temmc_do_upgrade "$1"
\t\t;;''')
add_case('platform_check_image', '''\tzbtlink,zbt-z8803be,mt7988a-emmc)
\t\t[ "$(dd if="$1" bs=1 skip=257 count=5 2>/dev/null)" = "ustar" ] || {
\t\t\techo "Invalid Z8803BE eMMC TAR image"
\t\t\treturn 1
\t\t}
\t\treturn 0
\t\t;;''')
add_case('platform_copy_config', '''\tzbtlink,zbt-z8803be,mt7988a-emmc)
\t\temmc_copy_config
\t\t;;''',False)
for func in ('platform_do_upgrade','platform_check_image','platform_copy_config'):
    block=s[s.index(func+'() {'):s.index('\n}',s.index(func+'() {'))]
    assert board in block
p.write_text(s)
print('Three eMMC paths injected:',board)
