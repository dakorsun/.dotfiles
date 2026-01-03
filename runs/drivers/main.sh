#!/usr/bin/env bash

set -euo pipefail

source $PWD/runs/drivers/detect/cpu.sh
source $PWD/runs/drivers/detect/gpu.sh

source $PWD/runs/drivers/install/audio.sh
source $PWD/runs/drivers/install/bluetooth.sh
source $PWD/runs/drivers/install/cpu.sh
source $PWD/runs/drivers/install/gpu.sh
source $PWD/runs/drivers/install/input.sh
source $PWD/runs/drivers/install/laptop.sh
source $PWD/runs/drivers/install/utils.sh

detect_cpu
detect_gpu

install_audio_drivers
install_bluetooth_drivers
install_cpu_drivers
install_gpu_drivers
install_input_drivers
install_laptop_tools
install_utils
