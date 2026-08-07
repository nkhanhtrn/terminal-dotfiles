#!/usr/bin/env bash
# Portable installer for AMD-APU power-profile desktop shortcuts.
#
# Creates three desktop shortcuts (Performance / Balanced / Power Saver) that
# each switch:
#   - the tuned profile            (sudo tuned-adm profile ...)
#   - the internal panel rate      (kscreen-doctor; skipped if HZ_* empty)
#   - the GPU max engine-clock cap (amdgpu overdrive, pp_od_clk_voltage)
#
# The GPU clock range is auto-detected, so the same script works across
# different AMD-APU laptops (Strix Halo, ThinkPad Z13, etc.).
#
# Usage:
#   ./install.sh
#   GPU_SAV=800 GPU_BAL=1600 ./install.sh        # customise the caps
#   PROFILE_BAL=balanced ./install.sh            # plain Fedora (not Bazzite)
#   HZ_SAV=42 HZ_BAL=42 HZ_PERF=41 ./install.sh  # enable the screen-Hz step
set -euo pipefail

if [ "$(id -u)" -eq 0 ]; then
    echo "Run this as your normal user, not root (it will sudo internally)." >&2
    exit 1
fi

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- tunables (override via env) -------------------------------------------------
GPU_SAV=${GPU_SAV:-1000}        # MHz cap for Power Saver
GPU_BAL=${GPU_BAL:-1800}        # MHz cap for Balanced
GPU_PERF=${GPU_PERF:-max}       # max = no cap (let the GPU boost fully)

PROFILE_SAV=${PROFILE_SAV:-powersave}
PROFILE_BAL=${PROFILE_BAL:-balanced-bazzite}     # use "balanced" on plain Fedora
PROFILE_PERF=${PROFILE_PERF:-accelerator-performance}

# kscreen-doctor mode ids for the internal panel. These are panel-specific, so
# they default to empty (the Hz step is skipped). Find yours with:
#   kscreen-doctor -o
# then set HZ_SAV / HZ_BAL / HZ_PERF accordingly at install time.
HZ_SAV=${HZ_SAV:-}
HZ_BAL=${HZ_BAL:-}
HZ_PERF=${HZ_PERF:-}

USER="${USER:-$(id -un)}"
USER_BIN="$HOME/bin"
DESKTOP_DIR="$HOME/Desktop"
POWER_SCRIPT="$USER_BIN/power-profile.sh"
HELPER_DST="/usr/local/bin/amdgpu-set-sclk-cap"
SUDOERS_FILE="/etc/sudoers.d/amdgpu-set-sclk-cap"

# --- sanity checks ---------------------------------------------------------------
command -v tuned-adm     >/dev/null || echo "WARNING: tuned-adm not found -- power-profile.sh will fail." >&2
command -v kscreen-doctor >/dev/null || echo "WARNING: kscreen-doctor not found; screen-Hz step will be skipped." >&2
command -v notify-send   >/dev/null || echo "WARNING: notify-send not found." >&2

OD_DEV=""
for d in /sys/class/drm/card*/device; do
    [ -e "$d/pp_od_clk_voltage" ] && { OD_DEV="$d"; break; }
done
MAXMHZ=""
[ -n "$OD_DEV" ] && MAXMHZ=$(awk '/^SCLK:/{gsub(/Mhz/,"");print $3;exit}' "$OD_DEV/pp_od_clk_voltage")
[ -z "$OD_DEV" ] && echo "WARNING: no amdgpu overdrive interface found -- GPU caps won't apply." >&2

warn_if_over() {  # value
    [ "$1" = max ] && return 0
    [ -z "$MAXMHZ" ] && return 0
    [ "$1" -gt "$MAXMHZ" ] && \
        echo "WARNING: $1 MHz exceeds this GPU's max ($MAXMHZ MHz); that cap won't apply." >&2
}
warn_if_over "$GPU_SAV"
warn_if_over "$GPU_BAL"

echo "=== Power Profiles setup ==="
echo "  user:     $USER"
echo "  GPU caps: saver=$GPU_SAV  balanced=$GPU_BAL  perf=$GPU_PERF${MAXMHZ:+  (this GPU max: $MAXMHZ MHz)}"
echo "  profiles: $PROFILE_SAV / $PROFILE_BAL / $PROFILE_PERF"
[ -z "$HZ_SAV$HZ_BAL$HZ_PERF" ] && echo "  Hz step:  SKIPPED (set HZ_SAV/HZ_BAL/HZ_PERF to enable)"
echo

# 1. user switcher script
mkdir -p "$USER_BIN"
install -m 0755 "$HERE/power-profile.sh" "$POWER_SCRIPT"

# 2. root helper + passwordless sudoers (root-owned, mode 0440)
sudo install -m 0755 -o root -g root "$HERE/amdgpu-set-sclk-cap" "$HELPER_DST"
TMP=$(mktemp)
echo "$USER ALL=(root) NOPASSWD: $HELPER_DST" > "$TMP"
sudo install -m 0440 -o root -g root "$TMP" "$SUDOERS_FILE"
rm -f "$TMP"
sudo visudo -cf "$SUDOERS_FILE" >/dev/null

# 3. desktop shortcuts (generated so paths/values match this machine)
mkdir -p "$DESKTOP_DIR"
gen_desktop() {  # file, display_name, label, icon, comment, profile, hz, gpu
    cat > "$DESKTOP_DIR/$1" <<EOF
[Desktop Entry]
Name=$2
Comment=$5
Exec=$POWER_SCRIPT "$6" "$3" "$7" "$8"
Icon=$4
Terminal=false
Type=Application
EOF
    chmod +x "$DESKTOP_DIR/$1"
}

gen_desktop "Power-Performance.desktop" "Power: Performance" "Performance" "battery-100" \
    "Performance + high refresh + GPU max"      "$PROFILE_PERF" "$HZ_PERF" "$GPU_PERF"
gen_desktop "Power-Balanced.desktop"    "Power: Balanced"    "Balanced"    "battery-070" \
    "Balanced + 60Hz + GPU ${GPU_BAL}MHz"       "$PROFILE_BAL"  "$HZ_BAL"  "$GPU_BAL"
gen_desktop "Power-Saver.desktop"       "Power: Saver"       "Power Saver" "battery-low" \
    "Power Saver + 60Hz + GPU ${GPU_SAV}MHz"    "$PROFILE_SAV"  "$HZ_SAV"  "$GPU_SAV"

echo "=== done ==="
echo "Shortcuts installed to: $DESKTOP_DIR"
echo "Verify the cap:  sudo $HELPER_DST 1000 && cat /sys/class/drm/card*/device/pp_od_clk_voltage"
