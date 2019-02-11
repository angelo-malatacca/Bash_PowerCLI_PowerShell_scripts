#Rimuovi Amministratori Locali Massivamente

#Questo script esegue le seguenti azioni:
#1.- Riceve una lista di pc da un file TXT
#2.- Riceve una lista di utenti che devono essere eliminati dal gruppo local admin da file TXT
#3.- Effettua un ping per ogni pc della lista, se il pc è offline passa al prossimo
#4.- Se il pc risponde al ping cerca nel gruppo local admins e se l'utente è uno di quelli inclusi nella lista lo rimuove
#5.- Crea un log con tutte le operazioni effettuate

# Log Time Variables
$Date = Get-Date -UFormat %b-%m-%Y
$Hour = (Get-Date).Hour
$Minuntes = (Get-Date).Minute
$Log = "C:\Scripts\Remove-LocalAdmins-" + $Date + "-" + $Hour + "-" + $Minuntes + ".log"

#Creazione log file per il processo
Start-Transcript -Path $Log  -Force 

#Lista dei computer da controllare
$ComputerNames = Get-Content ".\TestLocal.txt"

#Ping dei computers nella lista
foreach ($ComputerName in $ComputerNames) {

#Passa al successivo se il ping non risponde
if ( -not(Test-Connection $ComputerName -Quiet -Count 1 -ErrorAction Continue )) {
Write-Output "Computer $ComputerName non raggiungibile (PING) - Salto il computer..." }

#Se il computer risponde al ping
Else { Write-Output "Computer $computerName online"

#Ricerca nel gruppo Amministratori locali
$LocalGroupName = "Administrators"
$Group = [ADSI]("WinNT://$computerName/$localGroupName,group")
$Group.Members() |
foreach {
$AdsPath = $_.GetType().InvokeMember('Adspath', 'GetProperty', $null, $_, $null)
$A = $AdsPath.split('/',[StringSplitOptions]::RemoveEmptyEntries)
$Names = $a[-1] 
$Domain = $a[-2]

#Controlla la lista degli utenti che devono essere rimossi e ne verifica la presenza nel gruppo locale
foreach ($name in $names) {
Write-Output "Verifica amministratori locali su $computerName" 
$Admins = Get-Content ".\TestUsers.txt"
foreach ($Admin in $Admins) {
if ($name -eq $Admin) {

#Se trova una corrispondenza, avvisa e rimuove l'utente dal gruppo degli amministratori locali
Write-Output "Utente $Admin trovato sul computer $computerName ... "
$Group.Remove("WinNT://$computerName/$domain/$name")
Write-Output "Rimosso con successo" }}}}}

#Passes all the information of the operations made into the log file
}Stop-Transcript