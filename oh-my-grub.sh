#!/usr/bin/env bash

GRUB_NAME=""

function omg-help() {
  cat << EOF
$ omg update all            # Update all themes
$ omg update <theme-name>   # Update specific theme
$ omg themes                # All available themes
$ omg install <theme-name>  # install theme
$ omg install <url>         # install theme
$ omg list                  # All installed grub themes
$ omg theme <theme-name>    # Set grub theme
EOF
}

function omg-init() {
  echo "Init stuff"
  echo "$GRUB_NAME"
}

function omg-check-grub {
  # Check which grub using
  if [ -d "/boot/grub" ];then
    GRUB_NAME="grub"
  else
    GRUB_NAME="grub2"
  fi
}
function omg-check-privilege {
  # Check user is root
  if [ $UID == 0 ];then
    echo "Yes, You have privilege"
  else
    echo "No, You must be root!"
    exit 1
  fi
}
function omg-main() {
  omg-check-privilege
  omg-check-grub
  local Status=$1
  [ -z "$Status" ] && omg-init
  [ "$Status" = "help" ] || [ "$Status" = "--help" ] || [ "$Status" = "-h" ] && omg-help

}

omg-main "$@"
exit 0
