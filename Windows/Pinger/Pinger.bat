@Echo OFF

REM Questo semplice batch prova a pingare gli elementi
REM contenuti nel file elenco.txt e ne redirige l'esito
REM in un file di log chiamato logfile.txt

@Echo OFF

set log=logfile.txt

For /F "Usebackq Delims=" %%# in (
    ".\elenco.txt"
) do (
    Echo+
    Echo [+] Pinging: %%#

    Ping -a -n 4 "%%#" 1>nul && ( Echo [OK]) || ( Echo [FAILED]) 
    if errorlevel 1 ( 
    echo %%# Offline >> logfile.txt
    )
    echo %%# Online >> logfile.txt
    
)

Pause&Exit