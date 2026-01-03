#!/usr/bin/env bash

set -euo pipefail

source ./detect/cpu.sh
source ./detect/gpu.sh

source ./install/audio.sh
source ./install/bluetooth.sh
source ./install/cpu.sh
source ./install/gpu.sh
source ./install/input.sh
source ./install/laptop.sh
source ./install/utils.sh

detect_cpu
detect_gpu

install_audio_drivers
install_bluetooth_drivers
install_cpu_drivers
install_gpu_drivers
install_input_drivers
install_laptop_tools
install_utils
