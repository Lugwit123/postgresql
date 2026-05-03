@echo off
setlocal EnableExtensions

REM Shared environment defaults for PostgreSQL rez package scripts.
REM User-overridable:
REM   POSTGRES_DATA_DIR : data directory (PGDATA)
REM   POSTGRES_PORT     : port number (default 5432)
REM   POSTGRES_LOG      : logfile path
REM   POSTGRES_USER     : superuser name for initdb (default postgres)

if "%PGROOT%"=="" (
  echo [ERROR] PGROOT is not set. Please run inside rez: rez-env postgresql -- cmd
  exit /b 1
)

if not exist "%PGROOT%\bin\postgres.exe" (
  echo [ERROR] PostgreSQL payload not found at "%PGROOT%\bin\postgres.exe"
  echo [HINT] Put official Windows distribution under:
  echo        %POSTGRESQL_ROOT%\pgsql\...
  exit /b 2
)

if "%POSTGRES_PORT%"=="" set "POSTGRES_PORT=5432"
if "%POSTGRES_USER%"=="" set "POSTGRES_USER=postgres"

if "%POSTGRES_DATA_DIR%"=="" (
  set "POSTGRES_DATA_DIR=%LOCALAPPDATA%\Lugwit\PostgreSQL\data"
)

if "%POSTGRES_LOG%"=="" (
  set "POSTGRES_LOG=%LOCALAPPDATA%\Lugwit\PostgreSQL\postgresql.log"
)

for %%I in ("%POSTGRES_DATA_DIR%") do set "POSTGRES_DATA_DIR=%%~fI"
for %%I in ("%POSTGRES_LOG%") do set "POSTGRES_LOG=%%~fI"

endlocal & (
  set "PGROOT=%PGROOT%"
  set "POSTGRESQL_ROOT=%POSTGRESQL_ROOT%"
  set "POSTGRES_PORT=%POSTGRES_PORT%"
  set "POSTGRES_USER=%POSTGRES_USER%"
  set "POSTGRES_DATA_DIR=%POSTGRES_DATA_DIR%"
  set "POSTGRES_LOG=%POSTGRES_LOG%"
)

