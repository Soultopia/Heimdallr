#!/bin/bash

export VERSATILE_PATH=$(readlink -f $(dirname ${BASH_SOURCE}))
export PATH=$PATH:$VERSATILE_PATH
export PYTHONPATH=$PYTHONPATH:$VERSATILE_PATH


export PRJ_PATH=$(readlink -f $(dirname ${BASH_SOURCE}))
export RTL_PATH=$(readlink -f $(dirname ${BASH_SOURCE}))
export VER_PATH=$(readlink -f $(dirname ${BASH_SOURCE}))
export CMD_PATH=$(readlink -f $(dirname ${BASH_SOURCE}))
