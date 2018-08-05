#!/usr/bin/env bash

#  set-eGPU.sh
#  eGPU Setup
#
#  Created by Mayank Kumar on 8/5/18.
#  Copyright © 2018 Mayank Kumar. All rights reserved.

app_plist="${1}"
only_check="${2}"

if [[ -z "${app_plist}" ]]
then
    echo "Could not set."
    exit
fi

app_egpu_pref="$(defaults read "${app_plist}" GPUSelectionPolicy)"

result=""

if [[ "${app_egpu_pref}" != "preferRemovable" ]]
then
    if [[ "${only_check}" == "true" ]]
    then
        echo "Not preferred."
        exit
    fi
    result="$(defaults write "${app_plist}" GPUSelectionPolicy -string preferRemovable 2>&1)"
else
    if [[ "${only_check}" == "true" ]]
    then
        echo "Preferred."
        exit
    fi
    result="$(defaults write "${app_plist}" GPUSelectionPolicy -string default 2>&1)"
fi

if [[ ! -z "${result}" ]]
then
    echo "Could not set."
    exit
else
    echo "Set."
    exit
fi
