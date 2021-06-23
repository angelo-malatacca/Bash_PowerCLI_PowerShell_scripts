@ECHO OFF
rem This batch file will move the files 
rem from all the subfolder to a specific destination checking
rem if there are duplicates
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

echo "svuoto il cestino"
PowerShell.exe -NoProfile -Command Clear-RecycleBin -Confirm:$false

GOTO :EOF

:DupeRoutine
IF EXIST "%dest%\%~2_(%dupCnt%)%~3" (
    SET /A dupCnt=%dupCnt%+1
    CALL :DupeRoutine "%~1" "%~2" "%~3"
) ELSE (
    IF NOT EXIST "%dest%\%~2_(%dupCnt%)%~3" ECHO F | XCOPY /Y /F "%~1" "%dest%\%~2_(%dupCnt%)%~3" && DEL /Q /F "%~1"
    SET "dupCnt=1" 
    )

echo "svuoto il cestino"
PowerShell.exe -NoProfile -Command Clear-RecycleBin -Confirm:$false

GOTO :EOF

end