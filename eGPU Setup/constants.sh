#!/usr/bin/env bash

#  constants.sh
#  eGPU Setup
#
#  Created by Mayank Kumar on 8/1/18.
#  Copyright © 2018 Mayank Kumar. All rights reserved.

# Enable case-insensitive comparisons
shopt -s nocasematch

# System Model
SYS_MODEL="$(system_profiler SPHardwareDataType | grep -i 'Model Identifier' | cut -d ':' -f2 | awk '{$1=$1};1')"
TB_VER="$(ioreg | grep -i AppleThunderboltNHIType)"
SYS_TB_VER=""
TB_VAL=3

# AppleGPUWrangler references
TB_SWITCH_HEX="494F5468756E646572626F6C74537769746368547970653"

# IOGraphicsFamily references
PCI_TUNNELLED_HEX="494F50434954756E6E656C6C6564"
PATCHED_PCI_TUNNELLED_HEX="494F50434954756E6E656C6C6571"

# General kext paths
EXT_PATH="/System/Library/Extensions/"
TP_EXT_PATH="/Library/Extensions/"

## AppleGPUWrangler
AGC_PATH="${EXT_PATH}AppleGraphicsControl.kext"
SUB_AGW_PATH="/Contents/PlugIns/AppleGPUWrangler.kext/Contents/MacOS/AppleGPUWrangler"
AGW_BIN="${AGC_PATH}${SUB_AGW_PATH}"

## IONDRVSupport
IONDRV_PATH="${EXT_PATH}IONDRVSupport.kext"
IONDRV_PLIST_PATH="${IONDRV_PATH}/Info.plist"

## IOGraphicsFamily
IOG_PATH="${EXT_PATH}IOGraphicsFamily.kext"
SUB_IOG_PATH="/IOGraphicsFamily"
IOG_BIN="${IOG_PATH}${SUB_IOG_PATH}"

## NVDAStartup
NVDA_STARTUP_PATH="${TP_EXT_PATH}NVDAStartupWeb.kext"
NVDA_PLIST_PATH="${NVDA_STARTUP_PATH}/Contents/Info.plist"

## NVDAEGPUSupport
NVDA_EGPU_KEXT="${TP_EXT_PATH}NVDAEGPUSupport.kext"

## automate-eGPU
AUTOMATE_EGPU_DL=""
AUTOMATE_EGPU_ZIP="${TP_EXT_PATH}automate-eGPU.zip"
AUTOMATE_EGPU_KEXT="${TP_EXT_PATH}automate-eGPU.kext"
AMD_LEGACY_KEXT="${TP_EXT_PATH}AMDLegacySupport.kext"
DID_INSTALL_LEGACY_KEXT=0

# General backup path
SUPPORT_DIR="/Library/Application Support/eGPU Setup/"
BACKUP_KEXT_DIR="${SUPPORT_DIR}Kexts/"

## AppleGPUWrangler
BACKUP_AGC="${BACKUP_KEXT_DIR}AppleGraphicsControl.kext"
BACKUP_AGW_BIN="${BACKUP_AGC}${SUB_AGW_PATH}"

## IOGraphicsFamily
BACKUP_IOG="${BACKUP_KEXT_DIR}IOGraphicsFamily.kext"
BACKUP_IOG_BIN="${BACKUP_IOG}${SUB_IOG_PATH}"

## IONDRVSupport
BACKUP_IONDRV="${BACKUP_KEXT_DIR}IONDRVSupport.kext"

# PlistBuddy configuration
PlistBuddy="/usr/libexec/PlistBuddy"
NDRV_PCI_TUN_CP=":IOKitPersonalities:3:IOPCITunnelCompatible bool"
NVDA_PCI_TUN_CP=":IOKitPersonalities:NVDAStartup:IOPCITunnelCompatible bool"
NVDA_REQUIRED_OS=":IOKitPersonalities:NVDAStartup:NVDARequiredOS"
