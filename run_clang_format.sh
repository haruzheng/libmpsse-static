#!/bin/bash

set -e -x

# Uses .clang-format to format our project files!
find src -name "*.h" -exec clang-format-10 -style=file -i {} \;
find src -name "*.c" -exec clang-format-10 -style=file -i {} \;
