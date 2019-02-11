Connect-VIServer ""ip vcenter""
#Esempio: Connect-VIServer 192.168.150.100
$vmservers=Get-VM | Where-Object {$_.powerstate -eq ‘PoweredOn’};
$vmservers | select Name | export-csv path_salvataggio_file\nome_file.csv -NoTypeInformation
Disconnect-VIServer ""ip vcenter"" -Confirm:$false