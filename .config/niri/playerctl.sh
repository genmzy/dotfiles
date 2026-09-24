#!/bin/bash

op="play-pause"
if [ ${#1} -gt 0 ]; then
    op=$1
fi

all=0
active_players=()
while read -r player; do
    status=$(playerctl --player="$player" status 2>/dev/null)
    if [ "$status" = "Playing" ]; then
        active_players+=("$player")
    fi
    ((all += 1))
done < <(playerctl -l)

if [ ${#active_players[@]} -eq 1 ] && [ "$op" = "play-pause" ]; then
    target="${active_players[-1]}" # -1:latest 0:oldest
    playerctl --player="$target" "$op"
    notify-send --app-name="$target" "Player Stopped"
    exit 0
fi

if [ "$op" = "previous" ] || [ "$op" = "next" ]; then
    mapfile -t players < <(playerctl -l)
    candidates=()
    for p in "${players[@]}"; do
        case "${p,,}" in
            *firefox*) ;; # firefox gets the lowest priority
            *) candidates+=("$p") ;;
        esac
    done

    playing=()
    for p in "${candidates[@]}"; do
        [ "$(playerctl --player="$p" status 2>/dev/null)" = "Playing" ] && playing+=("$p")
    done

    if [ ${#players[@]} -eq 0 ]; then
        notify-send --app-name="playerctl" "No Player Instance"
    elif [ ${#playing[@]} -gt 0 ]; then
        playerctl --player="${playing[-1]}" "$op"
        notify-send --app-name="${playing[-1]}" "${op^}"
    elif [ ${#candidates[@]} -gt 0 ]; then
        playerctl --player="${candidates[-1]}" "$op"
        notify-send --app-name="${candidates[-1]}" "${op^}"
    else
        playerctl "$op"
        notify-send --app-name="playerctl" "Player ${op^}"
    fi
    exit 0
fi

if [ "$all" -eq 0 ]; then
    notify-send --app-name="playerctl" "No Player Instance"
elif [ ${#active_players[@]} -gt 0 ]; then
    playerctl "$op"
    notify-send --app-name="playerctl" "Player Started"
else
    playerctl "$op"
fi