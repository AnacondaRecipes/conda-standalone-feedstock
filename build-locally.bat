call conda activate
rmdir /s /q C:\opt\conda\conda-bld\conda-standalone-None
conda build . -c rdonnelly --build-id-pat={n}-{v} -m ..\..\a\conda_build_config-win-32.yaml | C:\msys32\usr\bin\tee C:\opt\conda\logs\conda-standalone-exe.win-32.log
