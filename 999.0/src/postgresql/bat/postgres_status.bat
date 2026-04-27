@echo off
chcp 65001 >nul 2>nul
setlocal EnableExtensions

call "%~dp0\_postgres_env.bat"
if errorlevel 1 exit /b %errorlevel%

pg_ctl -D "%POSTGRES_DATA_DIR%" status
exit /b %errorlevel%

