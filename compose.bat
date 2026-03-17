@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "cmd="
set "args="

:parse_args
if "%~1"=="" goto args_done
if not defined cmd (
  set "cmd=%~1"
) else (
  set "args=!args! ""%~1"""
)
shift
goto parse_args

:args_done
if not defined cmd set "cmd=up"

if /I "%cmd%"=="up" (
  call :set_compose_files
  docker compose !compose_files! up -d !args!
  goto :eof
)
if /I "%cmd%"=="down" (
  call :set_compose_files
  docker compose !compose_files! down --remove-orphans !args!
  goto :eof
)
if /I "%cmd%"=="logs" (
  call :set_compose_files
  docker compose !compose_files! logs -f !args!
  goto :eof
)
if /I "%cmd%"=="ps" (
  call :set_compose_files
  docker compose !compose_files! ps !args!
  goto :eof
)
if /I "%cmd%"=="build" (
  call :set_compose_files
  docker compose !compose_files! build !args!
  goto :eof
)
if /I "%cmd%"=="recreate" (
  call :set_compose_files
  docker compose !compose_files! down --remove-orphans
  if errorlevel 1 goto :eof
  docker compose !compose_files! up -d --force-recreate !args!
  goto :eof
)
if /I "%cmd%"=="rebuild" (
  call :set_compose_files
  docker compose !compose_files! build --no-cache !args!
  if errorlevel 1 goto :eof
  docker compose !compose_files! up -d --force-recreate !args!
  goto :eof
)
if /I "%cmd%"=="restart" (
  call :set_compose_files
  docker compose !compose_files! down --remove-orphans
  if errorlevel 1 goto :eof
  docker compose !compose_files! up -d !args!
  goto :eof
)
if /I "%cmd%"=="test" (
  call :set_compose_files
  docker compose !compose_files! -f tests/db/compose.yml run --rm test-db !args!
  if errorlevel 1 goto :eof
  docker compose !compose_files! -f tests/login/compose.yml run --rm test-login !args!
  if errorlevel 1 goto :eof
  docker compose !compose_files! -f tests/game/compose.yml run --rm test-game !args!
  goto :eof
)

echo Usage: compose ^<up^|down^|logs^|ps^|build^|recreate^|rebuild^|restart^|test^> [docker compose args]
exit /b 1

:set_compose_files
set "compose_files=-f docker-compose.yml"
for /f "delims=" %%F in ('where /r server compose.yml 2^>nul ^| sort') do (
  set "compose_files=!compose_files! -f ""%%~fF"""
)
goto :eof

