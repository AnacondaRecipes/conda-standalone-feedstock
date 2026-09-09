@ECHO ON
SET "PYINSTALLER_CONDARC_DIR=%RECIPE_DIR%"
IF NOT EXIST "%PYINSTALLER_CONDARC_DIR%" (
    ECHO "Could not find directory %PYINSTALLER_CONDARC_DIR%"
    EXIT /B 1
)
REM Create a .nonadmin file so that the menuinst tests
REM do not try to run with admin privileges
echo. > "%PREFIX%\.nonadmin"
:: miniforge_console_shortcut (conda-forge) is win-64 only
if "%ARCH%"=="arm64" (
    pytest -vvv -k "not test_menuinst and not test_uninstallation_menuinst and not test_conda_standalone_config"
) else (
    pytest -vvv -k "not test_conda_standalone_config"
)
IF %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
