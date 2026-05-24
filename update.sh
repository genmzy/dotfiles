#!/bin/bash

set -x

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <location> <app>, location can be 'config', 'local', '~' and '.'."
  exit 1
fi

prefix="$1"
app="$2"

case "$1" in
	"config")
		prefix=".config"
		;;
	"local")
		prefix=".local/share"
		;;
	"~")
		;&
	".")
		prefix="."
		;;
	*)
		echo "not supported location: $1, $0 <location> <app>, location can be 'config', 'local', '~' and '.'."
		exit 1;
		;;
esac

path="$prefix"/"$app"

if [ -d "$HOME"/"$path" ]; then
	if [ ! -d "$prefix"/"$app" ]; then
		mkdir -p "$path"
	fi
	cp -r "$HOME"/"$path"/* "$prefix"/"$app"/

elif [ -f "$HOME/$path" ]; then
	cp "$HOME"/"$path" "$prefix"/"$app"
fi
