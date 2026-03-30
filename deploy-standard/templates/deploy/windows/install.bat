@echo off
setlocal enabledelayedexpansion

set "REPO_URL={{REPO_URL}}"
set "PROJECT_DIR_NAME={{PROJECT_DIR_NAME}}"
set "INSTALL_DIR=%USERPROFILE%\Desktop\%PROJECT_DIR_NAME%"
set "PROJECT_ENV=%INSTALL_DIR%\.env"
set "VENV_DIR=%INSTALL_DIR%\venv"
set "DEPENDENCY_FILE={{DEPENDENCY_FILE}}"
set "START_COMMAND={{START_COMMAND}}"

if /i "{{REPO_VISIBILITY}}"=="private" (
    if not defined GITHUB_TOKEN (
        set /p GITHUB_TOKEN=Enter GitHub token: 
    )
    if not defined GITHUB_TOKEN (
        echo [ERROR] GitHub token is required for a private repository.
        goto :fail
    )
    set "CLONE_URL={{PRIVATE_CLONE_URL_TEMPLATE}}"
) else (
    set "CLONE_URL=%REPO_URL%"
)

echo.
echo === Project Install ===
echo.

where git >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Git is not installed.
    goto :fail
)

set "PYTHON_CMD="
where python >nul 2>&1 && set "PYTHON_CMD=python"
if not defined PYTHON_CMD where py >nul 2>&1 && set "PYTHON_CMD=py"
if not defined PYTHON_CMD (
    echo [ERROR] Python is not installed.
    goto :fail
)

if exist "%INSTALL_DIR%" (
    echo [ERROR] Install directory already exists:
    echo %INSTALL_DIR%
    echo [INFO] Remove it manually before running install again.
    goto :fail
)

echo [INFO] Cloning repository into %INSTALL_DIR%...
git clone "%CLONE_URL%" "%INSTALL_DIR%"
if errorlevel 1 goto :fail

if not exist "%INSTALL_DIR%\%DEPENDENCY_FILE%" (
    echo [ERROR] Missing dependency file: %DEPENDENCY_FILE%
    goto :fail
)

echo [INFO] Creating virtual environment...
%PYTHON_CMD% -m venv "%VENV_DIR%"
if errorlevel 1 goto :fail

call "%VENV_DIR%\Scripts\activate.bat"
echo [INFO] Installing dependencies...
pip install -r "%INSTALL_DIR%\%DEPENDENCY_FILE%"
if errorlevel 1 goto :fail

if exist "%INSTALL_DIR%\.env.example" (
    if not exist "%PROJECT_ENV%" copy "%INSTALL_DIR%\.env.example" "%PROJECT_ENV%" >nul
)

(
    echo @echo off
    echo call "%VENV_DIR%\Scripts\activate.bat"
    echo cd /d "%INSTALL_DIR%"
    echo %START_COMMAND%
) > "%INSTALL_DIR%\start.bat"

(
    echo @echo off
    echo git -C "%INSTALL_DIR%" pull --ff-only
    echo if errorlevel 1 exit /b 1
    echo call "%VENV_DIR%\Scripts\activate.bat"
    echo pip install --upgrade -r "%INSTALL_DIR%\%DEPENDENCY_FILE%"
) > "%INSTALL_DIR%\update.bat"

echo.
echo [OK] Installation completed.
echo [INFO] Project directory: %INSTALL_DIR%
if exist "%PROJECT_ENV%" echo [INFO] Fill in %PROJECT_ENV%
echo [INFO] Run start.bat to start the project.
pause
exit /b 0

:fail
pause
exit /b 1
