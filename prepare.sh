#!/usr/bin/env bash
set -euo pipefail

# Configuration
DEVICE="${1:-z8803be}"
PROFILE="${2:-release}"
ROOT_DIR="${ROOT_DIR:-.}"
CLONE_DEPTH="${CLONE_DEPTH:---depth=1}"

# Validate inputs
if [ -z "$DEVICE" ] || [ -z "$PROFILE" ]; then
  echo "Usage: $0 [DEVICE] [PROFILE]"
  echo "  DEVICE:  target device (default: z8803be)"
  echo "  PROFILE: build profile (default: release)"
  exit 1
fi

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

# Clone repository if needed
if [ ! -d "${WORKDIR}/.git" ]; then
  echo "Cloning ImmortalWrt..."
  git clone $CLONE_DEPTH --branch "${IMMORTALWRT_BRANCH}" "${IMMORTALWRT_REPO}" "${WORKDIR}" || {
    echo "ERROR: Failed to clone ImmortalWrt repository"
    exit 1
  }
else
  echo "ImmortalWrt directory already exists."
fi

# Change to work directory
cd "${WORKDIR}" || {
  echo "ERROR: Failed to enter ${WORKDIR}"
  exit 1
}

# Append custom feeds
if [ -f "${ROOT_DIR}/common/feeds.conf.append" ]; then
  echo "Appending custom feeds..."
  # Avoid duplicate appends
  if ! grep -qF -f "${ROOT_DIR}/common/feeds.conf.append" feeds.conf.default 2>/dev/null; then
    cat "${ROOT_DIR}/common/feeds.conf.append" >> feeds.conf.default
  else
    echo "Custom feeds already appended."
  fi
else
  echo "No custom feeds config found, using default feeds."
fi

# Update and install feeds
echo "Updating feeds..."
./scripts/feeds update -a || {
  echo "ERROR: Failed to update feeds"
  exit 1
}

echo "Installing feeds..."
./scripts/feeds install -a || {
  echo "ERROR: Failed to install feeds"
  exit 1
}

# Apply device configuration
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
  echo "Expected one of:"
  echo "  ${CONFIG_PROFILE}"
  echo "  ${CONFIG_DEFAULT}"
  exit 1
fi

# Apply overlay filesystem
OVERLAY_DIR="${ROOT_DIR}/devices/${DEVICE}/overlay"
if [ -d "${OVERLAY_DIR}" ]; then
  echo "Applying device overlay..."
  rsync -av "${OVERLAY_DIR}/" "${WORKDIR}/" || {
    echo "ERROR: Failed to apply overlay"
    exit 1
  }
else
  echo "No overlay directory found for ${DEVICE}."
fi

echo "✓ Prepare completed successfully."
