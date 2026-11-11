@echo off
chcp 65001 >nul
setlocal
rem ============================================================
rem  publish.cmd - push this folder to <username>.github.io
rem
rem  Usage:
rem    publish.cmd sanzhang
rem    publish.cmd sanzhang "Zhang San" "zhangsan@example.edu.cn"
rem
rem  Wraps deploy.ps1 with -ExecutionPolicy Bypass so that an
rem  unsigned-script policy cannot block the run.
rem ============================================================

cd /d "%~dp0"

if "%~1"=="" (
  echo [error] missing GitHub username.
  echo         usage: publish.cmd YOUR_GITHUB_USERNAME ["Your Name" "you@example.edu.cn"]
  exit /b 1
)

where git >nul 2>nul
if errorlevel 1 (
  echo [error] git not found. Install Git for Windows: https://git-scm.com/download/win
  exit /b 1
)

if not exist "index.html" (
  echo [error] index.html not found - run this from the personal-homepage folder.
  exit /b 1
)

set "USERNAME_ARG=%~1"
set "NAME_ARG=%~2"
set "EMAIL_ARG=%~3"

if not "%NAME_ARG%"=="" (
  powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0deploy.ps1" -UserName "%USERNAME_ARG%" -Name "%NAME_ARG%" -Email "%EMAIL_ARG%"
) else (
  powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0deploy.ps1" -UserName "%USERNAME_ARG%"
)

if errorlevel 1 (
  echo.
  echo [failed] see the message above.
  exit /b 1
)

echo.
echo [ok] wait 1-2 minutes, then open: https://%USERNAME_ARG%.github.io
endlocal
