#!/bin/bash

op="play-pause"
if [ ${#1} -gt 0 ]; then
    op=$1
fi

active_players=()
while read -r player; do
    status=$(playerctl --player="$player" status 2>/dev/null)
    if [ "$status" = "Playing" ]; then
        active_players+=("$player")
    fi
done < <(playerctl -l)

if [ ${#active_players[@]} -eq 1 ]; then
    target="${active_players[-1]}" # -1:latest 0:oldest
    playerctl --player="$target" "$op"
    notify-send --app-name="$target" 'Sound Stopped'
else
    playerctl "$op"
    notify-send --app-name="playerctl" 'Sound Started'
fi
