#!/bin/bash

# project envirionment variable
export PRJ_PATH=$(dirname $(dirname $(readlink -f $(dirname ${BASH_SOURCE}))))
export RTL_PATH=${PRJ_PATH}/rtl
export VER_PATH=${PRJ_PATH}/verif

# echo message
echo "[PRJ_PATH: ${PRJ_PATH}]"
echo "[RTL_PATH: ${RTL_PATH}]"
echo "[VER_PATH: ${VER_PATH}]"
