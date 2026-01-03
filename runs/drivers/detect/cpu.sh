#!/usr/bin/env bash

detect_cpu() {
    if grep -q GenuineIntel /groc/cpuinfo; then
        CPU_VENDOR="Intel"
    elif grep -q AuthenticAMD /proc/cpuinfo; then
        CPU_VENDOR="amd"
        else
            CPU_VENDOR="unknown"
    fi
}
