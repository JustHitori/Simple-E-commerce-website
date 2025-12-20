@echo off
setlocal

REM Adjust if your VS edition is different
set "MSBUILD=C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe"
set "IIS=%ProgramFiles%\IIS Express\iisexpress.exe"

REM Build solution
"%MSBUILD%" "%CD%\mwmasm.sln" /p:Configuration=Debug /t:Build
if errorlevel 1 exit /b 1

REM Run the web project folder (the one that contains Web.config and .aspx)
"%IIS%" /path:"%CD%\mwmasm" /port:5000 /systray:false
