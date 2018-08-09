#!/usr/bin/env bash

#  system_config.sh
#  eGPU Setup
#
#  Created by Mayank Kumar on 8/1/18.
#  Copyright © 2018 Mayank Kumar. All rights reserved.

# Retrieve constants
source "$1"

# System Integrity Protection
if [[ "$(csrutil status | grep -i "enabled")" ]]
then
    echo "Enabled"
else
    echo "Disabled"
fi

## System Model
echo "${SYS_MODEL}"

# System Thunderbolt Version
if [[ "${TB_VER}[@]" =~ "NHIType3" ]]
then
    echo "TB3 (40 Gb/s)"
    TB_VAL=3
elif [[ "${TB_VER}[@]" =~ "NHIType2" ]]
then
    echo "TB2 (20 Gb/s)"
    TB_VAL=2
elif [[ "${TB_VER}[@]" =~ "NHIType1" ]]
then
    echo "TB1 (10 Gb/s)"
    TB_VAL=1
else
    echo "-"
fi

# Patch check
check_patch() {
    if [[ ! -f "${AGW_BIN}" || ! -f "${IOG_BIN}" ]]
    then
        echo "Unknown"
        return
    fi
    AGW_HEX="$(hexdump -ve '1/1 "%.2X"' "${AGW_BIN}")"
    IOG_HEX="$(hexdump -ve '1/1 "%.2X"' "${IOG_BIN}")"
    SYS_TB_VER="${TB_SWITCH_HEX}${TB_VAL}"
    if [[ "${AGW_HEX}" =~ "${SYS_TB_VER}" && "${SYS_TB_VER}" != "${TB_SWITCH_HEX}"3 || -d "${AUTOMATE_EGPU_KEXT}" ]]
    then
        echo "AMD"
        return
    fi
    if [[ "${IOG_HEX}" =~ "${PATCHED_PCI_TUNNELLED_HEX}" && "$([[ -f "${NVDA_PLIST_PATH}" ]] && cat "${NVDA_PLIST_PATH}" | grep -i "IOPCITunnelCompatible")" ]]
    then
        echo "NVIDIA"
        return
    fi
}

check_patch
