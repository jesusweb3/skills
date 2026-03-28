@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

set "SERVICE_NAME={{PROJECT_SLUG}}"
set "DL_DIR=%TEMP%\%SERVICE_NAME%-bootstrap"
set "PY_URL=https://www.python.org/ftp/python/3.13.5/python-3.13.5-amd64.exe"
set "GIT_URL=https://github.com/git-for-windows/git/releases/download/v2.51.2.windows.1/Git-2.51.2-64-bit.exe"
set "PY_EXE=%DL_DIR%\python-3.13.5-amd64.exe"
set "GIT_EXE=%DL_DIR%\Git-2.51.2-64-bit.exe"
set "PY_LOG=%DL_DIR%\python_install.log"
set "GIT_LOG=%DL_DIR%\git_install.log"
set "PY_TARGET=%LOCALAPPDATA%\Programs\Python\Python313"
set "PY_BIN=%PY_TARGET%\python.exe"
set "GIT_BIN=%ProgramFiles%\Git\cmd\git.exe"
set "NEED_PY=0"
set "NEED_GIT=0"

echo.
echo === {{PROJECT_TITLE}} - Git/Python Setup ===
echo.

where git >nul 2>&1
if %errorlevel% neq 0 (
    set NEED_GIT=1
    echo [INFO] git not found, it will be installed
) else (
    echo [OK] git is already installed
)

set PYTHON_CMD=
where python >nul 2>&1 && set PYTHON_CMD=python
if not defined PYTHON_CMD where py >nul 2>&1 && set PYTHON_CMD=py
if not defined PYTHON_CMD (
    for /d %%D in ("%LOCALAPPDATA%\Programs\Python\Python*") do (
        if exist "%%D\python.exe" set "PYTHON_CMD=%%D\python.exe"
    )
)
if not defined PYTHON_CMD (
    for /d %%D in ("C:\Python*") do (
        if exist "%%D\python.exe" set "PYTHON_CMD=%%D\python.exe"
    )
)
if not defined PYTHON_CMD (
    set NEED_PY=1
    echo [INFO] python not found, it will be installed
) else (
    echo [OK] python is already installed: !PYTHON_CMD!
)

if "%NEED_PY%%NEED_GIT%"=="00" (
    echo.
    echo [OK] All dependencies are already installed.
    echo [INFO] Now run install.bat.
    pause
    exit /b 0
)

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] Administrator rights are required. Restarting...
    powershell -NoLogo -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

if not exist "%DL_DIR%" md "%DL_DIR%"

echo.
echo [INFO] Downloading installers...
where curl >nul 2>&1
if %errorlevel% neq 0 (
    if "%NEED_PY%"=="1" powershell -NoLogo -NoProfile -Command "Invoke-WebRequest '%PY_URL%' -OutFile '%PY_EXE%'"
    if "%NEED_GIT%"=="1" powershell -NoLogo -NoProfile -Command "Invoke-WebRequest '%GIT_URL%' -OutFile '%GIT_EXE%'"
) else (
    if "%NEED_PY%"=="1" curl -L -o "%PY_EXE%" "%PY_URL%" || goto :fail_download
    if "%NEED_GIT%"=="1" curl -L -o "%GIT_EXE%" "%GIT_URL%" || goto :fail_download
)

if "%NEED_PY%"=="1" (
    echo.
    echo [INFO] Installing Python 3.13.5...
    start /wait "" "%PY_EXE%" /quiet ^
      InstallAllUsers=0 ^
      TargetDir="%PY_TARGET%" ^
      Include_pip=1 ^
      Include_launcher=1 InstallLauncherAllUsers=0 ^
      PrependPath=1 ^
      Include_test=0 ^
      SimpleInstall=1 ^
      /log "%PY_LOG%"

    if not exist "%PY_BIN%" (
        echo [ERROR] Python not found after installation. Log: %PY_LOG%
        goto :fail
    )
    "%PY_BIN%" -V >nul 2>&1 || (
        echo [ERROR] Python is installed but does not start. Log: %PY_LOG%
        goto :fail
    )
    set PATH=%PY_TARGET%;%PY_TARGET%\Scripts;%PATH%
    echo [OK] Python installed: %PY_BIN%
)

if "%NEED_GIT%"=="1" (
    echo.
    echo [INFO] Installing Git...
    start /wait "" "%GIT_EXE%" /VERYSILENT /NORESTART /SP- ^
      /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS ^
      /LOG="%GIT_LOG%"

    if exist "%GIT_BIN%" (
        "%GIT_BIN%" --version >nul 2>&1 || (
            echo [ERROR] Git is installed but does not start. Log: %GIT_LOG%
            goto :fail
        )
        set PATH=%ProgramFiles%\Git\cmd;%PATH%
        echo [OK] Git installed: %GIT_BIN%
    ) else (
        where git >nul 2>&1 || (
            echo [ERROR] Git not found after installation. Log: %GIT_LOG%
            goto :fail
        )
        echo [OK] Git installed
    )
)

echo.
echo [INFO] Cleaning temporary files...
del /f /q "%PY_EXE%" "%GIT_EXE%" >nul 2>&1

echo.
echo [OK] Base dependencies are ready.
echo.
echo [INFO] Now run install.bat.
pause
exit /b 0

:fail_download
echo [ERROR] Failed to download installers.
pause
exit /b 1

:fail
pause
exit /b 1
