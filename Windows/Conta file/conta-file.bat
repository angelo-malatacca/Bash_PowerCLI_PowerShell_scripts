@echo off
rem This batch file will count and print the number 
rem of files with a specific extension 
rem (in this case .jpg) in all the subfolders
dir /b *.jpg /s 2> nul | find "" /v /c > tmp 
set /p downloaded=<tmp 
del tmp 
echo File scaricati: %downloaded%
pause