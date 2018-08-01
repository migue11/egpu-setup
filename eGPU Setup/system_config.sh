#!/usr/bin/env bash

if [[ "$(csrutil status | grep -i "enabled")" ]]
then
  echo "Enabled"
else
  echo "Disabled"
fi
sys_model="$(system_profiler SPHardwareDataType | grep -i 'Model Name' | cut -d ':' -f2 | awk '{$1=$1};1')"
echo "${sys_model}"
