```bash
#!/usr/bin/env bash

###############################################################################
# OpenRouterLab
# Prepare Build Environment
###############################################################################

set -euo pipefail

DEVICE="${1:-}"
PROFILE="${2:-release}"

ROOT_DIR="$(pwd)"
WORK_DIR="${ROOT_DIR}/immortalwrt"

if [[ -z "${DEVICE}" ]]; then
    echo "Usage:"
    echo "  ./scripts/prepare.sh <device> [profile]"
    exit 1
fi

echo "========================================"
echo " OpenRouterLab Prepare"
echo "========================================"
echo "Device : ${DEVICE}"
echo "Profile: ${PROFILE}"
echo "========================================"

###############################################################################
# Clone ImmortalWrt
###############################################################################

if [[ ! -d "${WORK_DIR}" ]]; then
    echo "[INFO] Cloning ImmortalWrt..."

    git clone \
        --depth=1 \
        https://github.com/immortalwrt/immortalwrt.git \
        "${WORK_DIR}"
fi

cd "${WORK_DIR}"

###############################################################################
# Copy custom feeds
###############################################################################

if [[ -f "${ROOT_DIR}/common/feeds.conf.default" ]]; then
    echo "[INFO] Installing custom feeds.conf.default"

    cp \
        "${ROOT_DIR}/common/feeds.conf.default" \
        feeds.conf.default
fi

###############################################################################
# Update feeds
###############################################################################

echo "[INFO] Updating feeds..."

./scripts/feeds update -a

echo "[INFO] Installing feeds..."

./scripts/feeds install -a

cd "${ROOT_DIR}"

###############################################################################
# Copy .config
###############################################################################

echo "[INFO] Installing device config..."

cp \
    "devices/${DEVICE}/config" \
    "${WORK_DIR}/.config"

###############################################################################
# Copy common files
###############################################################################

if [[ -d "common/files" ]]; then

    echo "[INFO] Copying common files..."

    rsync -a \
        common/files/ \
        "${WORK_DIR}/"
fi

###############################################################################
# Copy device files
###############################################################################

if [[ -d "devices/${DEVICE}/files" ]]; then

    echo "[INFO] Copying device files..."

    rsync -a \
        "devices/${DEVICE}/files/" \
        "${WORK_DIR}/"
fi

###############################################################################
# Apply patches
###############################################################################

PATCH_DIR="devices/${DEVICE}/patches"

if [[ -d "${PATCH_DIR}" ]]; then

    echo "[INFO] Applying patches..."

    cd "${WORK_DIR}"

    for patch in $(find "../${PATCH_DIR}" -name "*.patch" | sort)
    do
        echo "  -> $(basename "${patch}")"

        patch -p1 < "${patch}"
    done

    cd "${ROOT_DIR}"

fi

###############################################################################
# Copy DTS files
###############################################################################

if [[ -d "devices/${DEVICE}/dts" ]]; then

    echo "[INFO] Installing DTS files..."

    cp \
        devices/${DEVICE}/dts/* \
        "${WORK_DIR}/target/linux/mediatek/dts/"
fi

###############################################################################
# Profile
###############################################################################

echo "[INFO] Build profile: ${PROFILE}"

case "${PROFILE}" in

release)
    echo "Release profile selected."
    ;;

developer)
    echo "Developer profile selected."
    ;;

debug)
    echo "Debug profile selected."
    ;;

*)
    echo "Unknown profile."
    exit 1
    ;;

esac

###############################################################################
# Final
###############################################################################

echo
echo "========================================"
echo "Preparation complete."
echo "========================================"
```
