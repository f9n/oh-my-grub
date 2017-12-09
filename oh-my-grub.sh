#!/usr/bin/env bash

GRUB_NAME=""
CURRENT_GRUB_THEME=""
DOWNLOADED_THEMES=("")
AVAILABLE_THEMES=("Atomic")

function omg-compile-grub {
  ${GRUB_NAME}-mkconfig -o /boot/${GRUB_NAME}/grub.cfg
}

function omg-modify-grub-theme-path {
  echo "Modifying GRUB_THEME line in /etc/default/grub file"
}

function omg-download-theme {
  local url=$1
  local themename=$2
  git clone $url /tmp/$themename
  cp -rf /tmp/$themename /boot/${GRUB_NAME}/themes
}

function omg-backup-grub {
  cp -rf /boot/grub /boot/grub-backup-$(date '+%m-%d-%y_%H:%M:%S')
}


function omg-help {
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

function omg-init {
  echo "Init stuff"
  echo "$GRUB_NAME"
  echo "$CURRENT_GRUB_THEME"
  echo "${DOWNLOADED_THEMES[@]}"
  echo "${AVAILABLE_THEMES[@]}"
}

function omg-check-downloaded-themes {
  for themename in $(ls /boot/${GRUB_NAME}/themes); do
    DOWNLOADED_THEMES=(${DOWNLOADED_THEMES[@]} "$themename")
  done
}

function omg-learn-current-theme {
  # Example
  #   GRUB_THEME=/boot/grub/themes/Atomic/theme.txt
  #   GRUB_THEME=/boot/grub/themes/Atomic
  #   Atomic
  local result=$(grep GRUB_THEME < /etc/default/grub)
  local resultClean=${result%/*}
  CURRENT_GRUB_THEME=${resultClean##*/}
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
function omg-main {
  omg-check-privilege
  omg-check-grub
  omg-learn-current-theme
  omg-check-downloaded-themes
  local Status=$1
  [ -z "$Status" ] && omg-init
  [ "$Status" = "help" ] || [ "$Status" = "--help" ] || [ "$Status" = "-h" ] && omg-help

}

omg-main "$@"
exit 0
