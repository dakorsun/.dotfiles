#!/usr/bin/env bash

detect_gpu() {
    GPU=$(lspci | grep -E "VGA|3D")
}
