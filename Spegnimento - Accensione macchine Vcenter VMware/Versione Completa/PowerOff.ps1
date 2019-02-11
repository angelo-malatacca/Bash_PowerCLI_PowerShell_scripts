#################################################################################
# Power Off VMs                                                                 #
# Crea lista delle VM spente                                                    #
#Al momento le opzioni di spegnimento delle VM                                  #
#sono commentate per sicurezza                                                  #
#Stop-VM $VMname.Name -Confirm:$false ----> termina la macchina brutalmente     #
#$vm | Shutdown-VMGuest -Confirm:$false ----> effettua lo spegnimento dal S.O.  #
#################################################################################
 
###### Credenziali vCenter ######
 
Connect-VIServer ""ip vcenter"" 
#esempio: Connect-VIServer 192.168.100.150

cls
$Report=@()
$Record=@()
$NrVMsOff = 0
$NrVMsOn = 0
$NrVMsToolson = 0
$NrVMsToolsoff = 0
 
#Creazione report per Cluster
#Verifica PoweredON e PoweredOff VMs
#Commenta questa parte nella riga successiva | where { $_.PowerState -eq “PoweredOn”}, per far controllare tutte le macchine e non solo le PoweredON.

#$vms = Get-Cluster "Cluster Test"  | Get-vm | where { $_.PowerState -eq “PoweredOn”}
#Create report for full vCenter, remove comment if you want to use for all vCenter.
$vms = Get-vm | where { $_.PowerState -eq ‘PoweredOn’}
   
    foreach ($vm in $vms)
    {
    
        $VMname = Get-VM $vm | Select Name, @{N="Powerstate";E={($_).powerstate}}
           
        #Controllo stato VM
        if ($VMname.Powerstate -like "PoweredOff")
 
             {     
   Write-Host "VM --> ", $VMname.Name, " PowerOff, nessuna azione richiesta"
   $NrVMsOff = $NrVMsOff + 1
             }
         Elseif ($VMname.Powerstate -like "PoweredOn")              
               
            {  
                Write-Host "VM --> ", $VMname.Name, " è PoweredON, aggiornamento lista"
 $Report += $VMname.Name  
                $NrVMsOn = $NrVMsOn + 1
                                                
                #Creazione report
     Write-Host  "Elaborazione spegnimento VM -> " -f Blue -nonewline; Write-Host "$vm" -f red
 Write-Host “Verifica stato VM VMware Tools” -ForegroundColor Blue;Write-Host
 
 #Verifica stato VM VMware Tools
 $ToolsState = get-view -Id $vm.Id
 If ($ToolsState.config.Tools.ToolsVersion -eq 0)
 {
 $Record += “$vm ######  VMware tools non rilevati. Shutdown VM"
                 $NrVMsToolsoff = $NrVMsToolsoff + 1
 #Stop-VM $VMname.Name -Confirm:$false
 Sleep 3
 }
 
 Else
 
 {
 $Record += “$vm ######  VMware tools rilevati. Shutdown guest os”
                 $NrVMsToolson = $NrVMsToolson + 1
 $vm | Shutdown-VMGuest -Confirm:$false  
 Sleep 30
             }  
                         
             } 
    }  
 
$Record += ""
$Record += "#### Numero di VM spente ####"
$Record + $NrVMsToolsoff + " VM senza VMware Tools"
$Record + $NrVMsToolson + " VM con VMware Tools"
$Record + $NrVMsOn + " VM spente"
 
 
#VM Totali    
Write-Host $NrVMsToolsoff " VM senza VMware Tools"
Write-Host $NrVMsToolson " VM con VMware Tools"
Write-Host $NrVMsOn " VM spente"
Write-Host $NrVMsOff " VM già spente"  
Write-Host $NrVMsOn " VM avviate aggiunte alla lista PowerON"
write-host "Creazione reports ..."  
Sleep 3
 
$Path= "C:\temp\"
$PowerON = "$Path\PowerOnVMs.txt"
$PoweredOFF = "$Path\Record-Powered-Off-VMs-Prod.txt"
$Report | Out-File $PowerON 
$Record | Out-File $PoweredOFF 
      
#Disconnessione vCenter Server  
Disconnect-VIServer ""ip vcenter"" -Confirm:$false