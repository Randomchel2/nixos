#!/usr/bin/env bash

CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}' | cut -d. -f1)

# for nvidia
GPU_USAGE=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)

# for AMD
# GPU_USAGE=$(cat /sys/class/drm/card0/device/gpu_busy_percent)

echo "${CPU_USAGE}% | ${GPU_USAGE}%"
