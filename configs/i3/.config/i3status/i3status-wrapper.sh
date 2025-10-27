#! /usr/bin/env bash
i3status | while :
do
	read line
	layout=$(xkblayout-state print "%s" | tr '[:lower:]' '[:upper:]')
	echo " $layout | $line" || exit 1
done
