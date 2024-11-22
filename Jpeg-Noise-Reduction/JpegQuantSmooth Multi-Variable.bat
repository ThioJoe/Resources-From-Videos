:: Creates outputs of an image using JPegQuantSmooth using various combinations of different Quality and Iteration settings

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
set "outputdir=%filedir%%filename%_JQS_results"

REM Create the output directory if it doesn't exist
if not exist "%outputdir%" mkdir "%outputdir%"

REM Set the path to the jpegqs64.exe tool
set "toolpath=%~dp0jpegqs64.exe"

if not exist "%toolpath%" (
    echo Error: jpegqs64.exe not found in the script directory.
    echo Please ensure jpegqs64.exe is in the same directory as this script.
    pause
    exit /b 1
)

REM Loop over quality settings from 1 to 6
for /L %%q in (1,1,6) do (
    REM Loop over niter values: 3, 5, 10, and 20
    for %%n in (3 5 10 20) do (
        echo Processing with quality %%q and niter %%n...
        set "outputfile=%outputdir%\%filename%_q%%q_n%%n.jpg"
        "%toolpath%" -q %%q -n %%n "%inputfile%" "!outputfile!"
    )
)

echo Processing complete. Results are in "%outputdir%".
pause
