@echo off
chcp 65001 >nul 2>nul
setlocal EnableExtensions

call "%~dp0\_postgres_env.bat"
if errorlevel 1 exit /b %errorlevel%

if "%POSTGRES_DB%"=="" set "POSTGRES_DB=postgres"

echo [INFO] psql connect: host=127.0.0.1 port=%POSTGRES_PORT% db=%POSTGRES_DB% user=%POSTGRES_USER%
psql -h 127.0.0.1 -p %POSTGRES_PORT% -U "%POSTGRES_USER%" -d "%POSTGRES_DB%" %*

