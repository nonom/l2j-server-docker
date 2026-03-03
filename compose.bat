@echo off
setlocal EnableExtensions EnableDelayedExpansion

if "%~1"=="" goto :help

set "cmd=%~1"
shift

if /I "%cmd%"=="up" (
  docker compose up -d %*
  if errorlevel 1 goto :eof
  docker compose logs -f
  goto :eof
)

if /I "%cmd%"=="down" (
  docker compose down --remove-orphans %*
  goto :eof
)

if /I "%cmd%"=="logs" (
  docker compose logs -f %*
  goto :eof
)

if /I "%cmd%"=="ps" (
  docker compose ps %*
  goto :eof
)

if /I "%cmd%"=="recreate" (
  docker compose down
  if errorlevel 1 goto :eof
  docker compose up -d --force-recreate %*
  goto :eof
)

if /I "%cmd%"=="restart" (
  docker compose down --remove-orphans
  if errorlevel 1 goto :eof
  docker compose up -d %*
  if errorlevel 1 goto :eof
  docker compose logs -f
  goto :eof
)

if /I "%cmd%"=="custom" goto :custom

echo Unknown command: %cmd%
echo.
goto :help

:custom
set "compose_files=-f docker-compose.yml"
for /f "delims=" %%F in ('where /r custom compose.yml 2^>nul ^| sort') do (
  set "compose_files=!compose_files! -f ""%%~fF"""
)

docker compose !compose_files! up -d %*
if errorlevel 1 goto :eof

docker compose !compose_files! logs -f
goto :eof

:help
echo Usage: %~n0 ^<up^|down^|logs^|ps^|recreate^|restart^|custom^> [docker compose args]
echo.
echo Examples:
echo   %~n0 up
echo   %~n0 logs l2j-game-server
echo   %~n0 recreate --pull always
echo   %~n0 custom
exit /b 1
