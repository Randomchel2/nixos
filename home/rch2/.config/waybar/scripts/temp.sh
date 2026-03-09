#!/usr/bin/env bash

# CPU temperature
CPU_TEMP=$(sensors | grep "Package id 0" | awk '{print $4}' | cut -c2-3)

# nvidia gpu temperatur
GPU_TEMP=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)

# if you have AMD
# GPU_TEMP=$(sensors | grep "edge" | head -n 1 | awk '{print $2}' | cut -c2-3)

echo "${CPU_TEMP}°C | ${GPU_TEMP}°C"
