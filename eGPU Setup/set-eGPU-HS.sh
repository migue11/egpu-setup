#!/usr/bin/env bash

#  set-eGPU-HS.sh
#  eGPU Setup
#
#  Created by Mayank Kumar on 8/5/18.
#  Copyright © 2018 Mayank Kumar. All rights reserved.

APP_PLIST="${1}"
ONLY_CHECK="${2}"

if [[ -z "${APP_PLIST}" ]]
then
    echo "Could not set."
    exit
fi

APP_PREF="$(defaults read "${APP_PLIST}" GPUSelectionPolicy)"

RESULT=""

if [[ "${APP_PREF}" != "preferRemovable" ]]
then
    if [[ "${ONLY_CHECK}" == "true" ]]
    then
        echo "Not preferred."
        exit
    fi
    RESULT="$(defaults write "${APP_PLIST}" GPUSelectionPolicy -string preferRemovable 2>&1)"
else
    if [[ "${ONLY_CHECK}" == "true" ]]
    then
        echo "Preferred."
        exit
    fi
    RESULT="$(defaults write "${APP_PLIST}" GPUSelectionPolicy -string default 2>&1)"
fi

if [[ ! -z "${RESULT}" ]]
then
    echo "Could not set."
    exit
else
    echo "Set."
    exit
fi
