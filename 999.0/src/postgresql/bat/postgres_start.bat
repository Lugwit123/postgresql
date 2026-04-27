@echo off
chcp 65001 >nul 2>nul
setlocal EnableExtensions

call "%~dp0\_postgres_env.bat"
if errorlevel 1 exit /b %errorlevel%

if not exist "%POSTGRES_DATA_DIR%\PG_VERSION" (
  echo [WARN] Data directory not initialized yet.
  echo        Running postgres_init first...
  call "%~dp0\postgres_init.bat"
  if errorlevel 1 exit /b %errorlevel%
)

for %%I in ("%POSTGRES_LOG%") do (
  if not exist "%%~dpI" mkdir "%%~dpI" >nul 2>nul
)

echo [INFO] Starting PostgreSQL...
echo        DATA=%POSTGRES_DATA_DIR%
echo        PORT=%POSTGRES_PORT%
echo        LOG =%POSTGRES_LOG%

pg_ctl -D "%POSTGRES_DATA_DIR%" -l "%POSTGRES_LOG%" -o "-p %POSTGRES_PORT%" start
if errorlevel 1 (
  echo [ERROR] pg_ctl start failed.
  exit /b 5
)

echo [OK] started.
exit /b 0

