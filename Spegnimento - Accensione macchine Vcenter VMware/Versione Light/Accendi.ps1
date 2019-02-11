#Vcenter
Connect-VIServer ""ip vcenter""
#Esempio: Connect-VIServer 192.168.150.100

#Importa nome vm da file
$VMlist = Get-Content "path_salvataggio_file\nome_file.csv"

#ciclo accensione
foreach ($vm in $VMlist) {

$VMname = Get-VM $vm | Select Name

$vm | Start-VM -Confirm:$false

#aspettiamo 30 secondi per riaccendere la macchina successiva
#per non sovraccaricare il vcenter
Sleep 30


}

Disconnect-VIServer ""ip vcenter"" -Confirm:$false