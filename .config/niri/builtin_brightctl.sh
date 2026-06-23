#!/usr/bin/env bash

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

# echo "test: "
# get_builtin_backlight

DEVICE=$(get_builtin_backlight)
if [ -z "$DEVICE" ]; then
	echo "ERROR: Find no backlight devices" >&2
	exit 1
fi

brightnessctl -d "$DEVICE" --class=backlight set "$1"
