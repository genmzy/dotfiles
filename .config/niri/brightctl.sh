#!/usr/bin/bash

# Brightness control helper.
#
# Usage: brightctl.sh [--auto|--builtin] <+N%|N%-|+N|-N>
#
#   --auto     (default) If an external display is present, change its
#              brightness; otherwise change the built-in panel backlight.
#   --builtin  Always change the built-in panel backlight only.
#
# External display brightness, in order of preference:
#   1. Real DDC/CI via `dms brightness ... --ddc` (only for buses that DMS
#      can map through DRM sysfs, e.g. Intel gmbus connectors).
#   2. DMS "software" (gamma) brightness device, e.g. software:HDMI-A-1.
#      This is what DMS falls back to for outputs without accessible DDC,
#      like a monitor on the NVIDIA dGPU's HDMI port (NVIDIA does not expose
#      the ddc/i2c-N sysfs link that DMS needs to probe DDC).
#   3. Built-in panel backlight.

mode="auto"
case "${1:-}" in
    --auto)    mode="auto";    shift ;;
    --builtin) mode="builtin"; shift ;;
esac

arg="${1:-}"
if [ -z "$arg" ]; then
    echo "usage: $(basename "$0") [--auto|--builtin] <+N%|N%-|+N|-N>" >&2
    exit 1
fi

# Parse the step size and direction from forms like +1%, 1%-, +1, -1.
num=$(printf '%s' "$arg" | grep -oE '[0-9]+' | head -n1)
if [ -z "$num" ]; then
    echo "invalid brightness argument: $arg" >&2
    exit 1
fi
delta="$num"
if printf '%s' "$arg" | grep -q -- '-'; then
    delta="-$num"
fi

# Obtain the built-in screen backlight device (correct the connector name extraction)
get_builtin_backlight() {
    # Method 1: Reverse match the connector status through soft links
    for backlight_dev in /sys/class/backlight/*; do
        if [ -L "$backlight_dev" ]; then
            target=$(readlink -f "$backlight_dev")
            # Extract the connector name, for example: card1-eDP-1
            conn_name=$(echo "$target" | grep -oE "card[0-9]+-(eDP|LVDS)-[0-9]+")
            if [ -n "$conn_name" ]; then
                status_file="/sys/class/drm/$conn_name/status"
                if [ -f "$status_file" ] && grep -q "connected" "$status_file"; then
                    dev=$(basename "$backlight_dev")
                    echo "$dev"
                    return 0
                fi
            fi
        fi
    done

    # Method 2: Heuristic Fallback (Prioritize graphics card driver devices)
    mapfile -t devices < <(brightnessctl -l -c backlight | grep "Device" | awk -F"'" '{print $2}')
    for dev in "${devices[@]}"; do
        if [[ "$dev" =~ ^(intel_backlight|amdgpu_bl|nouveau_bl|i915) ]]; then
            echo "$dev"
            return 0
        fi
    done

    # Method 3: Take the first non-keyboard backlight device
    for dev in "${devices[@]}"; do
        if [[ "$dev" != "kbd_backlight" ]]; then
            echo "$dev"
            return 0
        fi
    done

    return 1
}

set_builtin() {
    DEVICE=$(get_builtin_backlight)
    if [ -z "$DEVICE" ]; then
        echo "ERROR: Find no backlight devices" >&2
        exit 1
    fi
    brightnessctl -d "$DEVICE" --class=backlight set "$arg"
}

# 1) Real DDC/CI via DMS (only buses DMS can map through DRM sysfs).
set_via_dms_ddc() {
    local ddc_dev cur new
    ddc_dev=$(dms brightness list --ddc 2>/dev/null | awk '$1 ~ /^ddc:/ { print $1; exit }')
    [ -z "$ddc_dev" ] && return 1

    cur=$(dms brightness get "$ddc_dev" --ddc 2>/dev/null \
        | grep -oE '[0-9]+%' | head -n1 | tr -d '%')
    [ -z "$cur" ] && cur=50

    new=$((cur + delta))
    [ "$new" -lt 0 ]   && new=0
    [ "$new" -gt 100 ] && new=100

    dms brightness set "$ddc_dev" "$new" --ddc >/dev/null 2>&1 || return 1
    return 0
}

# 2) DMS software (gamma) device for outputs without accessible DDC.
set_via_dms_software() {
    local sw_dev
    sw_dev=$(dms ipc call brightness list 2>/dev/null \
        | awk '$1 ~ /^software:/ { print $1; exit }')
    [ -z "$sw_dev" ] && return 1

    if [ "$delta" -gt 0 ]; then
        dms ipc call brightness increment "$num" "$sw_dev" >/dev/null 2>&1
    else
        dms ipc call brightness decrement "$num" "$sw_dev" >/dev/null 2>&1
    fi
    return $?
}

if [ "$mode" = "auto" ]; then
    if set_via_dms_software; then exit 0; fi
    if set_via_dms_ddc;    then exit 0; fi
fi

set_builtin
