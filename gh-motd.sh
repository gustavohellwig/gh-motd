#!/usr/bin/env bash
set -Eeuo pipefail

trap 'echo "ERROR: Installation failed on line $LINENO" >&2' ERR

# ==========================================================
# GH-MOTD Installer
# Repository: gustavohellwig/gh-motd
# ==========================================================

MOTD_DIR="/etc/update-motd.d"
MOTD_FILE="$MOTD_DIR/00-0welcome"
MOTD_URL="https://raw.githubusercontent.com/gustavohellwig/gh-motd/main/00-0welcome"
SSH_CONFIG="/etc/ssh/sshd_config"

echo
echo "=========================================================="
echo " GH-MOTD Installation"
echo "=========================================================="

if [[ $EUID -eq 0 ]]; then
    SUDO=""
else
    if ! command -v sudo >/dev/null 2>&1; then
        echo "ERROR: sudo is required to install GH-MOTD." >&2
        exit 1
    fi
    SUDO="sudo"
fi

# ----------------------------------------------------------
# 2. Install dependencies
# ----------------------------------------------------------

echo
echo "→ Installing dependencies"

$SUDO apt-get update  >/dev/null 2>&1
$SUDO apt-get install -y curl figlet lolcat >/dev/null 2>&1

# ----------------------------------------------------------
# 3. Download and install MOTD
# ----------------------------------------------------------

echo
echo "→ Downloading MOTD script"

DOWNLOAD_TMP=$(mktemp)
trap 'rm -f "${DOWNLOAD_TMP:-}"; echo "ERROR: Installation failed on line $LINENO" >&2' ERR

if ! curl -fsSL "$MOTD_URL" -o "$DOWNLOAD_TMP"; then
    echo "ERROR: Failed to download MOTD from:" >&2
    echo "$MOTD_URL" >&2
    exit 1
fi

# Validate the downloaded Bash script before installation.
if ! bash -n "$DOWNLOAD_TMP"; then
    echo "ERROR: Downloaded MOTD has invalid Bash syntax." >&2
    exit 1
fi

sudo find "$MOTD_DIR" -maxdepth 1 -type f ! -name "80-keyhelp" -exec chmod a-x {} + >/dev/null 2>&1
sudo find /etc/update-motd.d/ -maxdepth 1 -type l -delete >/dev/null 2>&1

$SUDO install -o root -g root -m 755 "$DOWNLOAD_TMP" "$MOTD_FILE"
rm -f "$DOWNLOAD_TMP"
unset DOWNLOAD_TMP

echo "MOTD installed: $MOTD_FILE"

# ----------------------------------------------------------
# 4. Configure PrintLastLog no
# ----------------------------------------------------------

echo
echo "→ Disabling the built-in SSH last-login message"

if [[ ! -f "$SSH_CONFIG" ]]; then
    echo "ERROR: SSH configuration not found: $SSH_CONFIG" >&2
    exit 1
fi

SSH_BACKUP="${SSH_CONFIG}.bak.$(date +%Y%m%d-%H%M%S)"
SSH_TMP=$(mktemp)

# Preserve the original SSH configuration.
$SUDO cp -a "$SSH_CONFIG" "$SSH_BACKUP"

if ! $SUDO awk '
    BEGIN {
        print "PrintLastLog no"
    }
    tolower($0) !~ /^[[:space:]]*printlastlog[[:space:]]+/ {
        print
    }
' "$SSH_CONFIG" > "$SSH_TMP"; then
    echo "ERROR: Could not prepare SSH configuration." >&2
    rm -f "$SSH_TMP"
    exit 1
fi

# Preserve the existing file permissions.
SSH_MODE=$($SUDO stat -c '%a' "$SSH_CONFIG")
$SUDO install -o root -g root -m "$SSH_MODE" \
    "$SSH_TMP" "$SSH_CONFIG"

rm -f "$SSH_TMP"

# Validate SSH before reloading.
if ! $SUDO /usr/sbin/sshd -t; then
    echo "ERROR: SSH configuration validation failed." >&2
    echo "Restoring backup: $SSH_BACKUP" >&2
    $SUDO cp -a "$SSH_BACKUP" "$SSH_CONFIG"
    exit 1
fi

# Reload SSH only after successful validation.
if ! $SUDO systemctl reload ssh; then
    echo "ERROR: SSH reload failed." >&2
    echo "Restoring backup: $SSH_BACKUP" >&2
    $SUDO cp -a "$SSH_BACKUP" "$SSH_CONFIG"
    $SUDO systemctl reload ssh || true
    exit 1
fi

echo "SSH configuration validated and reloaded."

# ----------------------------------------------------------
# 5. Final validation
# ----------------------------------------------------------

echo
echo "→ Validating installation"

$SUDO bash -n "$MOTD_FILE"
$SUDO /usr/sbin/sshd -t

echo
echo "Effective SSH PrintLastLog setting:"
$SUDO /usr/sbin/sshd -T | grep -i '^printlastlog '

echo
echo "MOTD permissions:"
$SUDO ls -l "$MOTD_FILE"

echo
echo "→ Installation completed successfully."
echo
echo "Testing your new dashboard:"
echo
sudo bash $MOTD_FILE
