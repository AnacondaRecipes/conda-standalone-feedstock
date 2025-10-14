@ECHO ON
SET "PYINSTALLER_CONDARC_DIR=%RECIPE_DIR%"
IF NOT EXIST "%PYINSTALLER_CONDARC_DIR%" (
    ECHO "Could not find directory %PYINSTALLER_CONDARC_DIR%"
    EXIT /B 1
)
:: Create a .nonadmin file so that the menuinst tests
:: do not try to run with admin privileges
echo. > "%PREFIX%\.nonadmin"
pytest -vvv -k "not test_conda_run"
IF %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
