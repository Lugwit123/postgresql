@echo off
chcp 65001 >nul 2>nul
setlocal EnableExtensions

call "%~dp0\_postgres_env.bat"
if errorlevel 1 exit /b %errorlevel%

echo [INFO] Stopping PostgreSQL...
echo        DATA=%POSTGRES_DATA_DIR%

pg_ctl -D "%POSTGRES_DATA_DIR%" stop -m fast
if errorlevel 1 (
  echo [ERROR] pg_ctl stop failed.
  exit /b 6
)

echo [OK] stopped.
exit /b 0

