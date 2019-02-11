#Questo script effettua il ping di elementi presi da un file di testo chiamato elenco.txt
#e ne redirige il risultato in un file di testo chiamato logfile.txt
#Se l'elemento risponde lo classifica UP, altrimenti Down, se nessuna delle precedenti
#condizioni vengono verificate lo classifica come IP non risolto

set-executionPolicy Unrestricted
$ping = New-Object System.Net.NetworkInformation.Ping
$hosts=Get-Content .\elenco.txt
$status=$null
$ip=$null
foreach ($hostname in $hosts) {
    try
    {
        $ip=([System.Net.Dns]::GetHostEntry($hostname).AddressList | %{$_.IPAddressToString})
    }
    catch [system.exception]
    {
        $ip = $null
    }
    if($ip -ne $null)
    {
        $Res = $ping.send($ip)
        if ($Res.Status -eq "OK")
        {
            $status=" è UP"
        }
        else 
        {
            $status="è DOWN"
        }
    }
    else
    {
        $ip="IP non risolto"
        $status=" è indefinito"
    }
 
    $result= $ip +"  "+ $Res+ $hostname+ $status
 
    Write-Host $result
    Add-Content ".\logfile.txt"  $result
    Clear-Variable ip,result,Res,status
}  
 
set-executionPolicy Restricted