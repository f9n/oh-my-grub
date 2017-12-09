#!/usr/bin/env bash

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
}

function omg-main() {
  local Status=$1
  [ -z "$Status" ] && omg-init
  [ "$Status" = "help" ] || [ "$Status" = "--help" ] || [ "$Status" = "-h" ] && omg-help

}

omg-main "$@"
exit 0
