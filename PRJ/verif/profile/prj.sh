#!/bin/bash


ENV_PATH=$(dirname $(dirname $(readlink -f $(dirname ${BASH_SOURCE}))))
source ${ENV_PATH}/verif/profile/path.sh
source ${ENV_PATH}/verif/profile/alia.sh
source ${ENV_PATH}/verif/profile/tool.sh
