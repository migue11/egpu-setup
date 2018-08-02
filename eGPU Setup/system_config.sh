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
echo "${sys_model}"

# System Thunderbolt Version
if [[ "${thunderbolt_version}[@]" =~ "NHIType3" ]]
then
    echo "TB3 (40 Gb/s)"
    tb_val=3
elif [[ "${thunderbolt_version}[@]" =~ "NHIType2" ]]
then
    echo "TB2 (20 Gb/s)"
    tb_val=2
elif [[ "${thunderbolt_version}[@]" =~ "NHIType1" ]]
then
    echo "TB1 (10 Gb/s)"
    tb_val=1
else
    echo "-"
fi

# Patch check
check_patch() {
    if [[ ! -f "${agw_bin}" || ! -f "${iog_bin}" ]]
    then
        echo "Unknown"
        return
    fi
    agw_hex="$(hexdump -ve '1/1 "%.2X"' "${agw_bin}")"
    iog_hex="$(hexdump -ve '1/1 "%.2X"' "${iog_bin}")"
    sys_tb_ver="${tb_switch_hex}${tb_val}"
    if [[ "${agw_hex}" =~ "${sys_tb_ver}" && "${sys_tb_ver}" != "${tb_switch_hex}"3 || -d "${automate_egpu_kext}" ]]
    then
        echo "AMD"
        return
    fi
    if [[ "${iog_hex}" =~ "${patched_iog_hex}" && "$([[ -f "${nvda_plist}" ]] && cat "${nvda_plist}" | grep -i "IOPCITunnelCompatible")" ]]
    then
        echo "NVIDIA"
        return
    fi
}

check_patch
