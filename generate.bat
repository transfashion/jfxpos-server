@echo off
set "GENERATE_ALL=false"
set "MODULE_NAME="

:parse_args
if "%~1"=="" goto run
if "%~1"=="--module" (
    set "MODULE_NAME=%~2"
    shift
    shift
    goto parse_args
)
if "%~1"=="--all" (
    set "GENERATE_ALL=true"
    shift
    goto parse_args
)
echo Argumen tidak dikenal: %~1
set "EXIT_CODE=1"
goto finish

:run
if "%GENERATE_ALL%"=="true" (
    echo Menjalankan generate untuk semua module...
    npm run generate all
    set "EXIT_CODE=%ERRORLEVEL%"
    goto finish
) else if not "%MODULE_NAME%"=="" (
    echo Menjalankan generate untuk module: %MODULE_NAME%...
    npm run generate %MODULE_NAME%
    set "EXIT_CODE=%ERRORLEVEL%"
    goto finish
) else (
    echo Error: Gunakan --module ^<namamodule^> atau --all
    echo Cara pakai: %~nx0 --module ^<namamodule^>
    echo             %~nx0 --all
    set "EXIT_CODE=1"
    goto finish
)

:finish
echo.
:: Cek apakah command prompt dijalankan dengan parameter /c (yang otomatis menutup window setelah selesai)
echo %CMDCMDLINE% | findstr /i /c:"/c" >nul
if %ERRORLEVEL% == 0 (
    cmd /k
)
exit /b %EXIT_CODE%



