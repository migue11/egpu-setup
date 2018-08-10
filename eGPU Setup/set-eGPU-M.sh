#!/bin/sh

#  set-eGPU-M.sh
#  eGPU Setup
#
#  Created by Mayank Kumar on 8/10/18.
#  Copyright © 2018 Mayank Kumar. All rights reserved.

APP_PLIST="${1}"
ONLY_CHECK="${2}"

PlistBuddy="/usr/libexec/PlistBuddy"
GPU_PLIST="${HOME}/Library/Preferences/com.apple.gpu.plist"

if [[ ! -e "${PlistBuddy}" || ! -e "${GPU_PLIST}" ]]
then
    echo "Could not set."
    exit
fi

if [[ -z "${APP_PLIST}" ]]
then
    echo "Could not set."
    exit
fi

APP_PREF="$($PlistBuddy -c "Print ${APP_PLIST}:GPUSelectionPolicy" "${GPU_PLIST}")"

RESULT=""

if [[ "${APP_PREF}" != "preferRemovable" ]]
then
    if [[ "${ONLY_CHECK}" == "true" ]]
    then
        echo "Not preferred."
        exit
    fi
    RESULT="$($PlistBuddy -c "Add ${APP_PLIST}:GPUSelectionPolicy string preferRemovable" "${GPU_PLIST}" 2>&1)"
else
    if [[ "${ONLY_CHECK}" == "true" ]]
    then
        echo "Preferred."
        exit
    fi
    RESULT="$($PlistBuddy -c "Delete ${APP_PLIST}" "${GPU_PLIST}" 2>&1)"
fi

if [[ ! -z "${RESULT}" ]]
then
    echo "Could not set."
    exit
else
    echo "Set."
    exit
fi
