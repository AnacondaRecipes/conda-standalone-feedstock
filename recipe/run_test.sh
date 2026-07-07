#!/bin/bash

set -ex

export PYINSTALLER_CONDARC_DIR="${RECIPE_DIR}"
test -d "${PYINSTALLER_CONDARC_DIR}"
# conda does not show plug-in settings with `conda config --shows-sources`
# This will be fixed with https://github.com/conda/conda/pull/16246
pytest -vvv -k 'not test_conda_standalone_config'
if [[ "$(uname)" == "Darwin" ]]; then
    test ! -e "${PREFIX}/bin/codesign"
fi
