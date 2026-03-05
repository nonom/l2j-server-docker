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

if /I "%cmd%"=="test" (
  docker compose -f docker-compose.yml -f tests/db/compose.yml run --rm test-db %*
  if errorlevel 1 goto :eof
  docker compose -f docker-compose.yml -f tests/login/compose.yml run --rm test-login %*
  if errorlevel 1 goto :eof
  docker compose -f docker-compose.yml -f tests/game/compose.yml run --rm test-game %*
  goto :eof
)

if /I "%cmd%"=="server" goto :server

echo Unknown command: %cmd%
echo.
goto :help

:server
set "compose_files=-f docker-compose.yml"
for /f "delims=" %%F in ('where /r server compose.yml 2^>nul ^| sort') do (
  set "compose_files=!compose_files! -f ""%%~fF"""
)

docker compose !compose_files! up -d %*
if errorlevel 1 goto :eof

docker compose !compose_files! logs -f
goto :eof

:help
echo Usage: %~n0 ^<up^|down^|logs^|ps^|recreate^|restart^|test^|server^> [docker compose args]
echo.
echo Example:
echo   %~n0 server
echo   %~n0 test
echo   %~n0 logs
echo   %~n0 down
exit /b 1
