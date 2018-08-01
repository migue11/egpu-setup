#!/usr/bin/env bash

#  constants.sh
#  eGPU Setup
#
#  Created by Mayank Kumar on 8/1/18.
#  Copyright © 2018 Mayank Kumar. All rights reserved.

# System Model
sys_model="$(system_profiler SPHardwareDataType | grep -i 'Model Identifier' | cut -d ':' -f2 | awk '{$1=$1};1')"

# System Thunderbolt Version
tb_val=3
thunderbolt_version="$(ioreg | grep AppleThunderboltNHIType)"

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
