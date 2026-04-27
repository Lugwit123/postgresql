@echo off
cls
REM Build/install postgresql rez package
chcp 65001 >nul 2>nul
set PYTHONIOENCODING=utf-8
cd /d "%~dp0"
REM Force using rez-packaged Python (no system python, no py_315).
set "REZ_SRC_ROOT=%~dp0..\.."
REM Ensure python-3.12 can be resolved from rez-package-source as well.
rez-env --paths "%REZ_SRC_ROOT%;%REZ_PACKAGES_PATH%" python-3.12 -- cmd /c "%wuwo_path%\wuwo.bat rez build -i"

