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
  if errorlevel 1 goto :eof
  docker compose !compose_files! logs -f
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
  call :set_compose_files
  docker compose !compose_files! build %*
  goto :eof
)
if /I "%cmd%"=="recreate" (
  call :set_compose_files
  docker compose !compose_files! down
  if errorlevel 1 goto :eof
  docker compose !compose_files! up -d --force-recreate %*
  if errorlevel 1 goto :eof
  docker compose !compose_files! logs -f
  goto :eof
)

if /I "%cmd%"=="rebuild" (
  call :set_compose_files
  docker compose !compose_files! build %*
  if errorlevel 1 goto :eof
  docker compose !compose_files! up -d --force-recreate %*
  if errorlevel 1 goto :eof
  docker compose !compose_files! logs -f
  goto :eof
)

if /I "%cmd%"=="restart" (
  call :set_compose_files
  docker compose !compose_files! down --remove-orphans
  if errorlevel 1 goto :eof
  docker compose !compose_files! up -d %*
  if errorlevel 1 goto :eof
  docker compose !compose_files! logs -f
  goto :eof
)

if /I "%cmd%"=="test" (
  for /f "delims=" %%F in ('where /r tests compose.yml 2^>nul ^| sort') do (
    docker compose -f docker-compose.yml -f "%%~fF" run --rm test %*
    if errorlevel 1 goto :eof
  )
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
