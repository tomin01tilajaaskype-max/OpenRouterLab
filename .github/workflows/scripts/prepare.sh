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
# Append custom feeds
###############################################################################

if [[ -f "${ROOT_DIR}/common/feeds.conf.append" ]]; then
    echo "[INFO] Appending custom feeds..."

    cat "${ROOT_DIR}/common/feeds.conf.append" >> feeds.conf.default
fi

###############################################################################
# Update feeds
###############################################################################

echo "[INFO] Updating feeds..."

./scripts/feeds update -a

echo "[INFO] Installing feeds..."

./scripts/feeds install -a
