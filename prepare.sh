#!/usr/bin/env bash
set -euo pipefail

DEVICE="${1:-z8803be}"
PROFILE="${2:-release}"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}").." && pwd)"
WORKDIR="${ROOT_DIR}/immortalwrt"

IMMORTALWRT_REPO="https://github.com/immortalwrt/immortalwrt.git"
IMMORTALWRT_BRANCH="master"

echo "========================================"
echo "Preparing firmware build"
echo "Device:  ${DEVICE}"
echo "Profile: ${PROFILE}"
echo "Root:    ${ROOT_DIR}"
echo "Workdir: ${WORKDIR}"
echo "========================================"

if [ ! -d "${WORKDIR}/.git" ]; then
  echo "Cloning ImmortalWrt..."
  git clone --depth=1     --branch "${IMMORTALWRT_BRANCH}"     "${IMMORTALWRT_REPO}"     "${WORKDIR}"
else
  echo "ImmortalWrt directory already exists."
fi

cd "${WORKDIR}"

if [ -f "${ROOT_DIR}/common/feeds.conf.append" ]; then
  echo "Appending custom feeds..."
  cat "${ROOT_DIR}/common/feeds.conf.append" >> feeds.conf.default
else
  echo "No common/feeds.conf.append found, using default feeds."
fi

echo "Updating feeds..."
./scripts/feeds update -a

echo "Installing feeds..."
./scripts/feeds install -a

CONFIG_PROFILE="${ROOT_DIR}/devices/${DEVICE}/config-${PROFILE}"
CONFIG_DEFAULT="${ROOT_DIR}/devices/${DEVICE}/.config"

if [ -f "${CONFIG_PROFILE}" ]; then
  echo "Using profile config: devices/${DEVICE}/config-${PROFILE}"
  cp "${CONFIG_PROFILE}" .config
elif [ -f "${CONFIG_DEFAULT}" ]; then
  echo "Using default config: devices/${DEVICE}/.config"
  cp "${CONFIG_DEFAULT}" .config
else
  echo "ERROR: Device configuration is missing."
  echo "Expected one of these files:"
  echo "  devices/${DEVICE}/config-${PROFILE}"
  echo "  devices/${DEVICE}/.config"
  exit 1
fi

OVERLAY_DIR="${ROOT_DIR}/devices/${DEVICE}/overlay"

if [ -d "${OVERLAY_DIR}" ]; then
  echo "Applying device overlay..."
  rsync -a "${OVERLAY_DIR}/" "${WORKDIR}/"
else
  echo "No overlay directory for ${DEVICE}, skipping."
fi

echo "Prepare completed successfully."
