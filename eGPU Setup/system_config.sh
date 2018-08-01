#!/usr/bin/env bash

# System Integrity Protection
if [[ "$(csrutil status | grep -i "enabled")" ]]
then
    echo "Enabled"
else
    echo "Disabled"
fi

# System Model
sys_model="$(system_profiler SPHardwareDataType | grep -i 'Model Identifier' | cut -d ':' -f2 | awk '{$1=$1};1')"
echo "${sys_model}"

# System Thunderbolt Version
tb_val=3
thunderbolt_version="$(ioreg | grep AppleThunderboltNHIType)"
if [[ "${thunderbolt_version}[@]" =~ "NHIType3" ]]
then
    echo "3 (40 Gb/s)"
    tb_val=3
elif [[ "${thunderbolt_version}[@]" =~ "NHIType2" ]]
then
    echo "2 (20 Gb/s)"
    tb_val=2
elif [[ "${thunderbolt_version}[@]" =~ "NHIType1" ]]
then
    echo "1 (10 Gb/s)"
    tb_val=1
else
    echo "-"
fi

# System eGPU Patch Status
ext_path="/System/Library/Extensions/"
tp_ext_path="/Library/Extensions/"
tb_switch_hex="494F5468756E646572626F6C74537769746368547970653"
patched_iog_hex="494F50434954756E6E656C6C6571"
automate_egpu_kext="${tp_ext_path}automate-eGPU.kext"
sys_tb_ver="${tb_switch_hex}${tb_val}"

## AppleGPUWrangler
agc_path="${ext_path}AppleGraphicsControl.kext"
sub_agw_path="/Contents/PlugIns/AppleGPUWrangler.kext/Contents/MacOS/AppleGPUWrangler"
agw_bin="${agc_path}${sub_agw_path}"

## IOGraphicsFamily
iog_path="${ext_path}IOGraphicsFamily.kext"
sub_iog_path="/IOGraphicsFamily"
iog_bin="${iog_path}${sub_iog_path}"

## NVDAStartup
nvda_startup="${tp_ext_path}NVDAStartupWeb.kext"
nvda_plist="${nvda_startup}/Contents/Info.plist"

# Patch check
check_patch() {
    if [[ ! -f "${agw_bin}" || ! -f "${iog_bin}" ]]
    then
        echo "Unknown"
        return
    fi
    agw_hex="$(hexdump -ve '1/1 "%.2X"' "${agw_bin}")"
    iog_hex="$(hexdump -ve '1/1 "%.2X"' "${iog_bin}")"
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
