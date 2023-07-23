@echo off

rem Variables
set "CWD=%CD%"
set "imager_path=C:\Program Files (x86)\Raspberry Pi Imager\rpi-imager.exe"
set "latest_imager_url=https://downloads.raspberrypi.org/imager/imager_latest.exe"
set "OUTPUT_FILE=imager_latest.exe"

rem For the moment, this is not needed
:: Check if the script is running as administrator
::>nul 2>&1 "%SYSTEMROOT%\System32\icacls.exe" "%SYSTEMROOT%\System32\config\system" && (
::    echo Running with administrator privileges
::) || (
::    echo Requesting elevated privileges...
::    powershell.exe -Command "Start-Process -FilePath '%0' -Verb RunAs"
::    exit /b
::)

if exist "%imager_path%" (
    echo RaspberryPi Imager installed, running ...
    goto StartImager
) else (
    echo RaspberryPi Imager not installed, downloading ...
    goto DownloadImager
)

rem Functions
:DownloadImager
echo Checking for the latest version of the RaspberryPi Imager ...
rem Using curl to follow redirects and extract final URL
::for /f "delims=" %%I in ('curl -s -L -w "%%{url_effective}" -o NUL %latest_imager_url%') do set "imager_url=%%I"
echo Downloading %latest_imager_url% ...
curl -L -o "%CWD%\%OUTPUT_FILE%" --progress-bar %latest_imager_url%
echo Running installer...
"%CWD%\%OUTPUT_FILE%"
echo Killing all running RaspberryPi Imagers
REM Get the list of processes named "imager.exe" and filter by the target directory
timeout /t 8 > nul
for /f "tokens=2 delims=," %%A in ('wmic process where "Name='imager.exe'" get CommandLine /format:csv') do (
    echo "%%A" | find /i "%imager_path%" > nul
    if not errorlevel 1 (
        taskkill /F /PID "%%A" > nul 2>&1
        echo Terminated process with PID "%%A" running from "%imager_path%"
    )
    echo Imager downloaded, running ...
    goto :StartImager
)

:StartImager
"%imager_path%" --debug --repo "https://furboianos.github.io/repo/imager/repo.json"