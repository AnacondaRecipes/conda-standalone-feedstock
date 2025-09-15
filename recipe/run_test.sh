#!/bin/bash

set -ex

export PYINSTALLER_CONDARC_DIR="${RECIPE_DIR}"
test -d "${PYINSTALLER_CONDARC_DIR}"
pytest -vvv
if [[ "$(uname)" == "Darwin" ]]; then
    test ! -e "${PREFIX}/bin/codesign"
fi
