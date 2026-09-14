#!/usr/bin/env bash
set -e

DIR="$HOME/.config/niri"
CONF="$DIR/touchpad_state.kdl"

if [ -f "$CONF" ]; then
    rm -f "$CONF"
    notify-send "Touchpad Enabled"
else
    cat > "$CONF" <<'EOF'
// Do NOT track this file in git. Touchpad on/off state lives here.
// Deleting this file reverts the touchpad to the defaults in config.kdl.
input {
    touchpad {
        off
        tap
        natural-scroll
    }
}
EOF
    notify-send "Touchpad Disabled"
fi
