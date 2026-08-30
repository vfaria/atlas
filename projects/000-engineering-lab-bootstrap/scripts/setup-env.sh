#!/usr/bin/env bash

if [[ -n "${BASH_SOURCE[0]:-}" ]]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
else
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
fi

PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

VCPKG_ROOT="${VCPKG_ROOT:-${HOME}/vcpkg}"
VCPKG_COMMIT="e12aaf7336cc1e348c43a1244f348451b534c0a9"

export VCPKG_ROOT

echo "Setting up Atlas development environment..."

# ---------------------------------------------------------------------------
# vcpkg
# ---------------------------------------------------------------------------

if [[ ! -d "${VCPKG_ROOT}" ]]; then
    echo "vcpkg not found. Cloning..."

    git clone https://github.com/microsoft/vcpkg.git "${VCPKG_ROOT}"
fi

cd "${VCPKG_ROOT}" || return 1

git fetch --quiet origin "${VCPKG_COMMIT}"

if [[ "$(git rev-parse HEAD)" != "${VCPKG_COMMIT}" ]]; then
    echo "Checking out vcpkg ${VCPKG_COMMIT}..."
    git checkout --quiet "${VCPKG_COMMIT}"
fi

if [[ ! -x "${VCPKG_ROOT}/vcpkg" ]]; then
    echo "Bootstrapping vcpkg..."
    ./bootstrap-vcpkg.sh -disableMetrics
fi

# ---------------------------------------------------------------------------
# LLVM
# ---------------------------------------------------------------------------

if ! command -v brew >/dev/null 2>&1; then
    echo "ERROR: Homebrew is required."
    return 1
fi

LLVM_PREFIX="$(brew --prefix llvm 2>/dev/null || true)"

if [[ -z "${LLVM_PREFIX}" || ! -d "${LLVM_PREFIX}" ]]; then
    echo "LLVM not found. Installing..."
    brew install llvm
    LLVM_PREFIX="$(brew --prefix llvm)"
fi

export PATH="${LLVM_PREFIX}/bin:${PATH}"

# ---------------------------------------------------------------------------
# Verification
# ---------------------------------------------------------------------------

cd "${PROJECT_ROOT}" || return 1

for tool in clang++ clang-tidy clang-format llvm-cov llvm-profdata cmake; do
    if ! command -v "${tool}" >/dev/null 2>&1; then
        echo "ERROR: ${tool} not found."
        return 1
    fi
done

echo
echo "Atlas development environment ready."
echo "  PROJECT_ROOT=${PROJECT_ROOT}"
echo "  VCPKG_ROOT=${VCPKG_ROOT}"
echo "  vcpkg=$(git -C "${VCPKG_ROOT}" rev-parse HEAD)"
echo "  clang++=$(command -v clang++)"
echo "  clang-tidy=$(command -v clang-tidy)"
echo "  clang-format=$(command -v clang-format)"
echo "  cmake=$(command -v cmake)"