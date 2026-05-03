@echo off
chcp 65001 >nul 2>&1
setlocal enabledelayedexpansion

REM ============================================================
REM  PostgreSQL Windows Binary Auto Download & Install
REM  - Downloads PostgreSQL 16.4 binary zip from EDB
REM  - Extracts to pgsql directory
REM  - Idempotent: skips if pgsql\bin\postgres.exe already exists
REM ============================================================

set "SCRIPT_DIR=%~dp0"
set "PG_VERSION=16.4-1"
set "ZIP_NAME=postgresql-%PG_VERSION%-windows-x64-binaries.zip"
set "ZIP_URL=https://get.enterprisedb.com/postgresql/%ZIP_NAME%"
set "TEMP_ZIP=%SCRIPT_DIR%%ZIP_NAME%"
set "PGSQL_DIR=%SCRIPT_DIR%pgsql"
set "POSTGRES_EXE=%PGSQL_DIR%\bin\postgres.exe"
set "MIN_SIZE=100000000"

echo ============================================================
echo   PostgreSQL %PG_VERSION% Windows Binary Installer
echo ============================================================
echo.

REM ------ Idempotency check ------
if exist "%POSTGRES_EXE%" (
    echo [INFO] PostgreSQL already exists: %POSTGRES_EXE%
    "%POSTGRES_EXE%" --version 2>nul
    echo [INFO] Skipping. To reinstall, delete the pgsql directory first.
    echo.
    goto :end
)

REM ------ Step 1: Download PostgreSQL binary zip ------
echo [1/4] Downloading PostgreSQL %PG_VERSION% binary zip ...
echo       URL: %ZIP_URL%
curl.exe --ssl-no-revoke -L -o "%TEMP_ZIP%" "%ZIP_URL%" --progress-bar
if %errorlevel% neq 0 (
    echo [ERROR] Failed to download PostgreSQL zip! Check network connection.
    goto :fail
)
if not exist "%TEMP_ZIP%" (
    echo [ERROR] Downloaded file not found: %TEMP_ZIP%
    goto :fail
)

REM ------ Validate downloaded zip file size (must be > 100MB) ------
set "FILE_SIZE=0"
for %%A in ("%TEMP_ZIP%") do set "FILE_SIZE=%%~zA"
if !FILE_SIZE! LSS %MIN_SIZE% (
    echo [ERROR] Downloaded file too small ^(!FILE_SIZE! bytes^), possibly corrupted or incomplete.
    echo [ERROR] Expected PostgreSQL binary zip to be greater than 100MB.
    del /f /q "%TEMP_ZIP%"
    goto :fail
)
echo [OK] Download complete. File size: !FILE_SIZE! bytes.
echo.

REM ------ Step 2: Extract zip ------
echo [2/4] Extracting to temporary directory ...
set "TEMP_EXTRACT=%SCRIPT_DIR%_pg_extract_temp"
if exist "%TEMP_EXTRACT%" rmdir /s /q "%TEMP_EXTRACT%"
mkdir "%TEMP_EXTRACT%"
powershell -NoProfile -Command "Expand-Archive -Path '%TEMP_ZIP%' -DestinationPath '%TEMP_EXTRACT%' -Force"
if %errorlevel% neq 0 (
    echo [ERROR] Extraction failed!
    goto :fail
)
echo [OK] Extraction complete.
echo.

REM ------ Step 3: Move pgsql directory to correct location ------
echo [3/4] Setting up pgsql directory ...
REM The zip contains a top-level 'pgsql' directory
if exist "%TEMP_EXTRACT%\pgsql" (
    echo       Found pgsql directory inside zip, moving ...
    if exist "%PGSQL_DIR%" rmdir /s /q "%PGSQL_DIR%"
    move "%TEMP_EXTRACT%\pgsql" "%PGSQL_DIR%" >nul
) else (
    echo       No pgsql subdirectory found, using extracted content directly ...
    if exist "%PGSQL_DIR%" rmdir /s /q "%PGSQL_DIR%"
    move "%TEMP_EXTRACT%" "%PGSQL_DIR%" >nul
)
if not exist "%POSTGRES_EXE%" (
    echo [ERROR] postgres.exe not found after extraction. Check zip integrity.
    goto :fail
)
echo [OK] pgsql directory ready.
echo.

REM ------ Step 4: Clean up ------
echo [4/4] Cleaning up temp files ...
if exist "%TEMP_ZIP%" del /f /q "%TEMP_ZIP%"
if exist "%TEMP_EXTRACT%" rmdir /s /q "%TEMP_EXTRACT%"
echo [OK] Cleanup complete.
echo.

REM ------ Done ------
echo ============================================================
echo   [SUCCESS] PostgreSQL %PG_VERSION% installation complete!
echo ============================================================
echo.
echo   Location: %PGSQL_DIR%
"%POSTGRES_EXE%" --version 2>nul
echo.
echo   To initialize the database, run:
echo     src\postgresql\bat\postgres_init.bat
echo.
goto :end

:fail
echo.
echo [FATAL] Error during PostgreSQL installation, cleaning up ...
if exist "%TEMP_ZIP%" del /f /q "%TEMP_ZIP%"
if exist "%TEMP_EXTRACT%" rmdir /s /q "%TEMP_EXTRACT%"
echo Please check the error messages above and retry.
exit /b 1

:end
endlocal
pause
