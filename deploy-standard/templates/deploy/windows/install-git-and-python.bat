@echo off
setlocal enabledelayedexpansion

set "DL_DIR=%TEMP%\bootstrap-tools"
set "PY_URL=https://www.python.org/ftp/python/{{PYTHON_VERSION}}/python-{{PYTHON_VERSION}}-amd64.exe"
set "GIT_URL=https://github.com/git-for-windows/git/releases/download/{{GIT_RELEASE_TAG}}/Git-{{GIT_INSTALLER_VERSION}}-64-bit.exe"
set "PY_EXE=%DL_DIR%\python-{{PYTHON_VERSION}}-amd64.exe"
set "GIT_EXE=%DL_DIR%\Git-{{GIT_INSTALLER_VERSION}}-64-bit.exe"
set "NEED_PY=0"
set "NEED_GIT=0"

echo.
echo === Bootstrap Git and Python ===
echo.

where git >nul 2>&1
if errorlevel 1 (
    set "NEED_GIT=1"
    echo [INFO] Git is missing and will be installed.
) else (
    echo [OK] Git is already installed.
)

where python >nul 2>&1
if errorlevel 1 (
    where py >nul 2>&1
    if errorlevel 1 (
        set "NEED_PY=1"
        echo [INFO] Python is missing and will be installed.
    ) else (
        echo [OK] Python launcher is already installed.
    )
) else (
    echo [OK] Python is already installed.
)

if "%NEED_PY%%NEED_GIT%"=="00" (
    echo.
    echo [OK] Base tools are already available.
    pause
    exit /b 0
)

net session >nul 2>&1
if errorlevel 1 (
    echo [INFO] Administrator rights are required. Restarting as administrator...
    powershell -NoLogo -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

if not exist "%DL_DIR%" mkdir "%DL_DIR%"

where curl >nul 2>&1
if errorlevel 1 (
    echo [ERROR] curl is required for bootstrap download.
    pause
    exit /b 1
)

if "%NEED_PY%"=="1" curl -L -o "%PY_EXE%" "%PY_URL%" || goto :fail_download
if "%NEED_GIT%"=="1" curl -L -o "%GIT_EXE%" "%GIT_URL%" || goto :fail_download

if "%NEED_PY%"=="1" (
    echo [INFO] Installing Python...
    start /wait "" "%PY_EXE%" /quiet InstallAllUsers=0 PrependPath=1 Include_pip=1 Include_test=0
    where python >nul 2>&1
    if errorlevel 1 goto :fail
    echo [OK] Python installed.
)

if "%NEED_GIT%"=="1" (
    echo [INFO] Installing Git...
    start /wait "" "%GIT_EXE%" /VERYSILENT /NORESTART /SP-
    where git >nul 2>&1
    if errorlevel 1 goto :fail
    echo [OK] Git installed.
)

echo.
echo [OK] Bootstrap completed.
pause
exit /b 0

:fail_download
echo [ERROR] Failed to download installers.
pause
exit /b 1

:fail
echo [ERROR] Bootstrap failed.
pause
exit /b 1
