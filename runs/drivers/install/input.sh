#!/usr/bin/env bash

install_input_drivers(){
    sudo pacman -S --needed \
        libinput xf86-input-libinput
}
