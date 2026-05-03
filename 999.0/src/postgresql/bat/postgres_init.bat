@echo off
chcp 65001 >nul 2>nul
setlocal EnableExtensions

call "%~dp0\_postgres_env.bat"
if errorlevel 1 exit /b %errorlevel%

if exist "%POSTGRES_DATA_DIR%\PG_VERSION" (
  echo [INFO] Data directory already initialized:
  echo        %POSTGRES_DATA_DIR%
  exit /b 0
)

echo [INFO] Initializing PostgreSQL data directory...
echo        PGROOT=%PGROOT%
echo        DATA=%POSTGRES_DATA_DIR%
echo        USER=%POSTGRES_USER%

mkdir "%POSTGRES_DATA_DIR%" >nul 2>nul
if errorlevel 1 (
  echo [ERROR] Failed to create data directory: %POSTGRES_DATA_DIR%
  exit /b 3
)

REM --auth=trust is convenient for local dev; override as needed in production.
initdb -D "%POSTGRES_DATA_DIR%" -U "%POSTGRES_USER%" --encoding=UTF8 --auth=trust
if errorlevel 1 (
  echo [ERROR] initdb failed.
  exit /b 4
)

echo [OK] initdb done.
exit /b 0

