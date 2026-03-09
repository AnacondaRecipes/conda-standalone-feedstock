@ECHO on

"%PYTHON%" "%RECIPE_DIR%\copy_patches.py" ^
  --patch-source "%SRC_DIR%\src\conda_patches" ^
  --site-packages "%SP_DIR%" ^
  --conda-source conda_src || goto :error

:: we need these for noarch packages with entry points to work on windows
echo PREFIX=%PREFIX% BUILD_PREFIX=%BUILD_PREFIX% ARCH=%ARCH%
set "found="
for %%P in ("%PREFIX%" "%BUILD_PREFIX%") do (
  for %%M in (conda_build conda-build) do (
    if exist "%%~P\Lib\site-packages\%%M\cli-%ARCH%.exe" (
      COPY "%%~P\Lib\site-packages\%%M\cli-%ARCH%.exe" entry_point_base.exe || goto :error
      set "found=1"
      goto :copied
    )
  )
)
:copied
if defined found (
  echo copied entry_point_base.exe
) else (
  echo Could not find cli-%ARCH%.exe in PREFIX or BUILD_PREFIX
  dir "%PREFIX%\Lib\site-packages\conda*" || dir "%BUILD_PREFIX%\Lib\site-packages\conda*"
  goto :error
)

pyinstaller --clean --log-level=DEBUG src\conda.exe.spec || goto :error
set "variant=%variant%"
if "%variant%" == "onedir" (
  MKDIR "%PREFIX%"
) else (
  MKDIR "%PREFIX%\standalone_conda"
)
MOVE dist\conda.exe "%PREFIX%\standalone_conda" || goto :error

:: Collect licenses
"%PYTHON%" src\licenses.py ^
  --prefix "%BUILD_PREFIX%" ^
  --include-text ^
  --text-errors replace ^
  --output "%SRC_DIR%\3rd-party-licenses.json" || goto :error

RD /s /q "%PREFIX%\lib" || goto :error

goto :EOF

:error
set "exitcode=%errorlevel%"
echo Failed with error #%exitcode%.
exit /b %exitcode%
