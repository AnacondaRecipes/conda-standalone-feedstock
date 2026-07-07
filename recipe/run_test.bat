@ECHO ON
SET "PYINSTALLER_CONDARC_DIR=%RECIPE_DIR%"
IF NOT EXIST "%PYINSTALLER_CONDARC_DIR%" (
    ECHO "Could not find directory %PYINSTALLER_CONDARC_DIR%"
    EXIT /B 1
)
REM Create a .nonadmin file so that the menuinst tests
REM do not try to run with admin privileges
echo. > "%PREFIX%\.nonadmin"
REM conda does not show plug-in settings with `conda config --shows-sources`
REM This will be fixed with https://github.com/conda/conda/pull/16246
pytest -vvv -k "not test_conda_standalone_config"
IF %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
