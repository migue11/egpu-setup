#!/usr/bin/env bash

#  detect-eGPU.sh
#  eGPU Setup
#
#  Created by Mayank Kumar on 8/19/18.
#  Copyright © 2018 Mayank Kumar. All rights reserved.
#  Adapted from @goalque's automate-eGPU.sh

EGPU_VENDOR="$(ioreg -n display@0 | grep \"vendor-id\" | cut -d "=" -f2 | sed 's/ <//' | sed 's/>//' | cut -c1-4 | sed -E 's/^(.{2})(.{2}).*$/\2\1/')"
EGPU_DEVICE_ID="$(ioreg -n display@0 | grep \"device-id\" | cut -d "=" -f2 | sed 's/ <//' | sed 's/>//' | cut -c1-4 | sed -E 's/^(.{2})(.{2}).*$/\2\1/')"
DEVICE_NAMES="$(curl -s "http://pci-ids.ucw.cz/read/PC/${EGPU_VENDOR}/${EGPU_DEVICE_ID}" | grep -i "itemname" | sed -E "s/.*Name\: (.*)$/\1/")"
DEVICE_NAME="$(echo "${DEVICE_NAMES}" | tail -1 | cut -d '[' -f2)"
[[ ! -z "${DEVICE_NAME}" ]] && echo "${DEVICE_NAME%?}"
if [[ "${EGPU_VENDOR}" == "10de" ]]
then
    echo "NVIDIA"
elif [[ "${EGPU_VENDOR}" == "1002" ]]
then
    echo "AMD"
fi
