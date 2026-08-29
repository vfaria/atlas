#!/usr/bin/env bash

set -euo pipefail

# Project root: parent of scripts/
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# vcpkg
if [[ -z "${VCPKG_ROOT:-}" ]]; then
    export VCPKG_ROOT="${HOME}/vcpkg"
fi

if [[ ! -x "${VCPKG_ROOT}/vcpkg" ]]; then
    echo "ERROR: vcpkg not found at ${VCPKG_ROOT}"
    echo "Set VCPKG_ROOT to your vcpkg installation."
    exit 1
fi

# LLVM
if command -v brew >/dev/null 2>&1; then
    LLVM_PREFIX="$(brew --prefix llvm)"
    export PATH="${LLVM_PREFIX}/bin:${PATH}"
fi

# Make the environment visible to the caller when sourced.
echo "Atlas development environment"
echo "  PROJECT_ROOT=${PROJECT_ROOT}"
echo "  VCPKG_ROOT=${VCPKG_ROOT}"
echo "  clang++=$(command -v clang++ || echo 'not found')"
echo "  clang-tidy=$(command -v clang-tidy || echo 'not found')"
echo "  clang-format=$(command -v clang-format || echo 'not found')"