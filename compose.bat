@echo off
setlocal EnableExtensions EnableDelayedExpansion

if "%~1"=="" (
  set "cmd=up"
) else (
  set "cmd=%~1"
  shift
)

if /I "%cmd%"=="up" (
  call :set_compose_files
  docker compose !compose_files! up -d %*
  goto :eof
)
if /I "%cmd%"=="down" (
  call :set_compose_files
  docker compose !compose_files! down --remove-orphans %*
  goto :eof
)
if /I "%cmd%"=="logs" (
  call :set_compose_files
  docker compose !compose_files! logs -f %*
  goto :eof
)
if /I "%cmd%"=="ps" (
  call :set_compose_files
  docker compose !compose_files! ps %*
  goto :eof
)
if /I "%cmd%"=="build" (
  call :set_compose_build_files
  docker compose !compose_files! build %*
  goto :eof
)
if /I "%cmd%"=="recreate" (
  call :set_compose_files
  docker compose !compose_files! down --remove-orphans
  if errorlevel 1 goto :eof
  docker compose !compose_files! up -d --force-recreate %*
  goto :eof
)
if /I "%cmd%"=="rebuild" (
  call :set_compose_build_files
  docker compose !compose_files! build --no-cache %*
  if errorlevel 1 goto :eof
  call :set_compose_files
  docker compose !compose_files! up -d --force-recreate %*
  goto :eof
)
if /I "%cmd%"=="restart" (
  call :set_compose_files
  docker compose !compose_files! down --remove-orphans
  if errorlevel 1 goto :eof
  docker compose !compose_files! up -d %*
  goto :eof
)
if /I "%cmd%"=="test" (
  call :set_compose_files
  docker compose !compose_files! -f tests/db/compose.yml run --rm test-db %*
  if errorlevel 1 goto :eof
  docker compose !compose_files! -f tests/login/compose.yml run --rm test-login %*
  if errorlevel 1 goto :eof
  docker compose !compose_files! -f tests/game/compose.yml run --rm test-game %*
  goto :eof
)

echo Unknown command: %cmd%
echo Usage: %~n0 ^<up^|down^|logs^|ps^|build^|recreate^|rebuild^|restart^|test^> [docker compose args]
exit /b 1

:set_compose_files
set "compose_files=-f docker-compose.yml"
for /f "delims=" %%F in ('where /r server compose.yml 2^>nul ^| sort') do (
  set "compose_files=!compose_files! -f ""%%~fF"""
)
goto :eof

:set_compose_build_files
set "compose_files=-f docker-compose.yml"
for /f "delims=" %%F in ('where /r server compose.yml 2^>nul ^| sort') do (
  set "compose_files=!compose_files! -f ""%%~fF"""
)
for /f "delims=" %%F in ('where /r build compose.yml 2^>nul ^| sort') do (
  set "compose_files=!compose_files! -f ""%%~fF"""
)
goto :eof
