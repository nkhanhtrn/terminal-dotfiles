#!/usr/bin/env bash
# power-profile.sh -- switch a power plan atomically:
#   1. tuned profile            (arg 1, via sudo tuned-adm)
#   2. internal panel refresh   (arg 3, via kscreen-doctor; empty = skip)
#   3. GPU max engine-clock cap (arg 4, via amdgpu-set-sclk-cap; empty = skip)
#
# Usage: power-profile.sh <tuned-profile> <label> <hz> <gpu-mhz|'max'>
set -e
PROFILE="$1"
LABEL="$2"
HZ="$3"
GPUMHZ="$4"

sudo /usr/bin/tuned-adm profile "$PROFILE"

if [ -n "$HZ" ]; then
    kscreen-doctor output.2.mode.$HZ
fi

if [ -n "$GPUMHZ" ]; then
    sudo /usr/local/bin/amdgpu-set-sclk-cap "$GPUMHZ" || \
        notify-send "Power Plan" "GPU clock cap failed" -i dialog-warning
fi

notify-send "Power Plan" "Switched to ${LABEL}" -i preferences-system-power-management
