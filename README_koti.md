# OpenRouterLab

![OpenRouterLab](docs/logo.png)

OpenRouterLab is an open-source build environment for developing custom OpenWrt / ImmortalWrt firmware for modern 5G routers.

The goal of this project is to provide a clean, modular and reproducible firmware build system supporting multiple hardware platforms while sharing a common build infrastructure.

---

# Project Goals

OpenRouterLab aims to provide:

* Modern Linux kernel
* Latest ImmortalWrt Snapshot
* MediaTek Unified Build Support
* Qualcomm Build Support
* GitHub Actions CI/CD
* Automatic Releases
* Reproducible Builds
* Modular Device Support

---

# Supported Platforms

## MediaTek

### ZBT Z8803BE

Hardware

* MediaTek MT7988A
* 1 GB DDR4
* eMMC Storage
* WiFi 7
* Qualcomm Snapdragon X62
* USB QMI Modem

Status

🚧 In Development

---

### Feiyan M60K63

Hardware

* MediaTek MT7986A
* 1 GB DDR4
* RM551N-GL
* USB QMI

Status

🚧 In Development

---

## Qualcomm

### OG50FQT

Hardware

* Qualcomm IPQ9574
* Snapdragon X75
* WiFi 7
* mmWave

Status

📋 Planned

---

# Firmware Profiles

## Release

Recommended for daily use.

Includes

* LuCI
* HTTPS
* WireGuard
* ZeroTier
* DDNS
* Cloudflare DDNS
* No-IP DDNS
* USB QMI Support
* MBIM Support

---

## Developer

Includes everything from Release plus

* bash
* nano
* vim
* tcpdump
* strace
* htop
* usbutils
* pciutils
* ethtool
* iperf3

---

## Debug

Developer profile with additional kernel debugging enabled.

---

# Repository Structure

```text
OpenRouterLab/

.github/
common/
devices/
docs/
hardware/
profiles/
scripts/

README.md
LICENSE
CHANGELOG.md
```

---

# Device Structure

Each supported router has its own directory.

```text
devices/

m60k63/

z8803be-emmc/

og50fqt/
```

Each device contains

* config
* DTS
* patches
* files
* documentation

---

# Build System

The project is based on

* ImmortalWrt Snapshot
* MediaTek Unified Build System
* GitHub Actions
* Automatic Releases

---

# Features

* GitHub Actions
* Automatic Firmware Builds
* Automatic Releases
* HTTPS
* LuCI
* WireGuard
* ZeroTier
* QMI
* MBIM
* USB Modem Support
* Cloudflare DDNS
* No-IP DDNS
* OpenVPN
* SQM
* Multi-WAN (planned)

---

# License

MIT License

---

# Disclaimer

This project is intended for advanced users.

Always keep a recovery method available before flashing custom firmware.
