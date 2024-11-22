:: Creates outputs of an image using Jpeg2PNG using various combinations of different Weight and Iteration settings

@echo off
setlocal enabledelayedexpansion

REM Get the input file path
set "inputfile=%~1"
set "filename=%~n1"
set "filedir=%~dp1"

REM Check if input file was provided
if "%~1"=="" (
    echo Error: No input file specified.
    echo Please drag and drop an image file onto this batch file to use it.
    pause
    exit /b 1
)

REM Set the output directory
set "outputdir=%filedir%%filename%_J2P_results"

REM Create the output directory if it doesn't exist
if not exist "%outputdir%" mkdir "%outputdir%"

REM Set the path to the jpeg2png.exe tool
set "toolpath=%~dp0jpeg2png.exe"

if not exist "%toolpath%" (
    echo Error: jpeg2png.exe not found in the script directory.
    echo Please ensure jpeg2png.exe is in the same directory as this script.
    pause
    exit /b 1
)

REM Define the values for -w (weight) option
set "weights=0 0.25 0.3 0.5 0.75 1"

REM Define the values for -i (iterations) option
set "iterations=50 75 100 125 150"

REM Loop over weight values
for %%w in (%weights%) do (
    REM Remove dot from weight value for filename
    set "w_clean=%%w"
    set "w_clean=!w_clean:.=p!"

    REM Loop over iteration values
    for %%i in (%iterations%) do (
        echo Processing with weight %%w and iterations %%i...
        set "outputfile=%outputdir%\%filename%_w!w_clean!_i%%i.png"
        "%toolpath%" "%inputfile%" -w %%w -i %%i -o "!outputfile!"
    )
)

echo Processing complete. Results are in "%outputdir%".
pause
