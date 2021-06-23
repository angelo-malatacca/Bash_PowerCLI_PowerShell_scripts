@echo off
rem This batch file will delete all the folders and subfolders
rem who have the selected name (change folder_name with the name
rem of the folder you want delete), then count the number of the
rem files with a specific extension (in this case .jpg)
rem in all the subfolders, empty the bin, and move the files 
rem from all the subfolder to a specific destination checking
rem if there are duplicates
setlocal enabledelayedexpansion
echo "search directories"
for /f "usebackq tokens=*" %%i in (`dir /b /s /a:d folder_name`) do (
  echo "deleting the "%%i" directory and any files or subdirectories"
  rd /s /q "%%i"
  )
for /f "usebackq tokens=*" %%l in (`dir /b /s /a:d folder_name2`) do (
  echo "deleting the "%%l" directory and any files or subdirectories"
  rd /s /q "%%l"
  )
for /f "usebackq tokens=*" %%h in (`dir /b /s /a:d folder_name3`) do (
  echo "deleting the "%%h" directory and any files or subdirectories"
  rd /s /q "%%h"
  )

echo *********************************************************************

dir /b *.jpg /s 2> nul | find "" /v /c > tmp 
set /p downloaded=<tmp 
del tmp 
echo File scaricati: %downloaded%

echo *********************************************************************
timeout 5

echo "svuoto il cestino"
PowerShell.exe -NoProfile -Command Clear-RecycleBin -Confirm:$false

echo "sposto i file"
SET "source=C:\Users\123456\abcd"
SET "dest=C:\Users\987654\abcd"
SET "FileList=*.jpg"

SET "dupCnt=1"

FOR /R "%source%" %%A IN (%FileList%) DO (
    IF NOT EXIST "%dest%\%%~NXA" (
        XCOPY /F /Y "%%~FA" "%dest%\" && IF EXIST "%%~FA" DEL /Q /F "%%~FA"
    ) ELSE (
        CALL :DupeRoutine "%%~FA" "%%~NA" "%%~XA"
        )
    )
GOTO :EOF

:DupeRoutine
IF EXIST "%dest%\%~2_(%dupCnt%)%~3" (
    SET /A dupCnt=%dupCnt%+1
    CALL :DupeRoutine "%~1" "%~2" "%~3"
) ELSE (
    IF NOT EXIST "%dest%\%~2_(%dupCnt%)%~3" ECHO F | XCOPY /Y /F "%~1" "%dest%\%~2_(%dupCnt%)%~3" && DEL /Q /F "%~1"
    SET "dupCnt=1" 
    )
GOTO :EOF
end