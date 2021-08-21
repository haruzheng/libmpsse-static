#!/bin/bash
set -x -e

BUILD_DIR=build

if [ -n "${CLEAN}" ]; then
   rm -rf "${BUILD_DIR}"
fi

cmake -B "${BUILD_DIR}" .
make -C "${BUILD_DIR}"
