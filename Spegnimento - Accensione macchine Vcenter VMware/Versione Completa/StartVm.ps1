#################################
# Importa VMs da file e PowerON #
#################################
 
###### Credenziali vCenter ######
 
Connect-VIServer ""ip vcenter"" 
#Esempio: Connect-VIServer 192.168.100.150

cls
 
$Report=@()
$NrVMsOff = 0
$NrVMsOn = 0
   
#Importa nome vm da file
$VMlist = Get-Content "C:\temp\Record-Powered-Off-VMs-Prod.txt"   
     
 foreach ($vm in $VMlist)
 {
 $VMname = Get-VM $vm | Select Name, @{N="Powerstate";E={($_).powerstate}}
        
 #Controllo VM   
        if ($VMname.Powerstate -like "PoweredOff") 
 {
    	Write-Host "VM --> ", $VMname.Name, " la macchina è PowerOff, si procede all'avvio " 
 Start-VM -VM $VMname.Name -Verbose:$false
            	Sleep 10 
 
 $Report += "VM --> " + $VMname.Name + " la macchina è PowerOff, si procede all'avvio "  
 $NrVMsOff = $NrVMsOff + 1 
 }    
        Elseif ($VMname.Powerstate -like "PoweredOn")
 {  
                Write-Host "VM --> ", $VMname.Name, " la macchina è PowerON, nessuna azione richiesta "
                                   
 #Creazione report   
                $Report += "VM --> " + $VMname.Name + " la macchina è PowerON, nessuna azione richiesta "  
 $NrVMsOn = $NrVMsOn + 1                
            }  
    }  
 
$Report + $NrVMsOn + " macchine già PowerON"
$Report + $NrVMsOff + " macchine avviate"
write-host "Creazione report ..."  
Sleep 3
 
$Path= "C:\temp\"
$PowerOff = "$Path\Report-Accensione-Prod.txt"
$Report | Out-File $PowerOff
      
#Disconnessione vCenter Server  
Disconnect-VIServer ""ip vcenter"" -Confirm:$false