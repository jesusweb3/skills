@echo off
chcp 65001 >nul

set "REPO_URL={{REPO_URL}}"
set "BRANCH_NAME={{DEPLOY_BRANCH}}"
set "SERVICE_NAME={{PROJECT_SLUG}}"
set "INSTALL_DIR=%USERPROFILE%\Desktop\%SERVICE_NAME%"
set "SERVICE_ENV=%INSTALL_DIR%\.env"
set "VENV_DIR=%INSTALL_DIR%\venv"

echo.
echo === {{PROJECT_TITLE}} - Install ===
echo.

where git >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] git is not installed.
    goto :fail
)
echo [OK] git found

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
    echo [ERROR] python not found in PATH or standard locations.
    goto :fail
)
echo [OK] python found: %PYTHON_CMD%

if exist "%INSTALL_DIR%" (
    echo [INFO] %SERVICE_NAME% is already installed at %INSTALL_DIR%
    echo [INFO] Nothing to do.
    pause
    exit /b 0
)

echo [INFO] Cloning into %INSTALL_DIR%...
git clone --branch %BRANCH_NAME% %REPO_URL% "%INSTALL_DIR%"
if %errorlevel% neq 0 goto :fail_clone
echo [OK] Repository ready

echo [INFO] Creating virtual environment...
%PYTHON_CMD% -m venv "%VENV_DIR%"
if %errorlevel% neq 0 goto :fail_venv
echo [OK] Virtual environment ready

echo [INFO] Installing dependencies...
call "%VENV_DIR%\Scripts\activate.bat"
pip install -q -r "%INSTALL_DIR%\requirements.txt"
if %errorlevel% neq 0 goto :fail_pip
echo [OK] Dependencies installed

if not exist "%SERVICE_ENV%" if exist "%INSTALL_DIR%\.env.example" (
    copy "%INSTALL_DIR%\.env.example" "%SERVICE_ENV%" >nul
)
echo [OK] Configuration ready

echo @echo off> "%INSTALL_DIR%\start.bat"
echo chcp 65001 ^>nul>> "%INSTALL_DIR%\start.bat"
echo call "%VENV_DIR%\Scripts\activate.bat">> "%INSTALL_DIR%\start.bat"
echo cd /d "%INSTALL_DIR%">> "%INSTALL_DIR%\start.bat"
echo python {{PYTHON_ENTRYPOINT}}>> "%INSTALL_DIR%\start.bat"
echo pause>> "%INSTALL_DIR%\start.bat"
echo [OK] Created start.bat

echo @echo off> "%INSTALL_DIR%\update.bat"
echo chcp 65001 ^>nul>> "%INSTALL_DIR%\update.bat"
echo echo [INFO] Updating...>> "%INSTALL_DIR%\update.bat"
echo git -C "%INSTALL_DIR%" fetch origin %BRANCH_NAME% --prune>> "%INSTALL_DIR%\update.bat"
echo git -C "%INSTALL_DIR%" checkout %BRANCH_NAME%>> "%INSTALL_DIR%\update.bat"
echo git -C "%INSTALL_DIR%" pull --ff-only origin %BRANCH_NAME%>> "%INSTALL_DIR%\update.bat"
echo call "%VENV_DIR%\Scripts\activate.bat">> "%INSTALL_DIR%\update.bat"
echo pip install -q -r "%INSTALL_DIR%\requirements.txt">> "%INSTALL_DIR%\update.bat"
echo echo [OK] Updated. Restart start.bat>> "%INSTALL_DIR%\update.bat"
echo pause>> "%INSTALL_DIR%\update.bat"
echo [OK] Created update.bat

echo.
echo ============================================
echo   Installation complete!
echo.
echo   Folder: %INSTALL_DIR%
echo.
echo   1. Edit .env:
echo      %SERVICE_ENV%
echo.
echo   2. Run start.bat
echo ============================================
echo.

pause
exit /b 0

:fail_clone
echo [ERROR] Failed to clone repository.
pause
exit /b 1

:fail_venv
echo [ERROR] Failed to create virtual environment.
pause
exit /b 1

:fail_pip
echo [ERROR] Failed to install dependencies.
pause
exit /b 1

:fail
pause
exit /b 1
