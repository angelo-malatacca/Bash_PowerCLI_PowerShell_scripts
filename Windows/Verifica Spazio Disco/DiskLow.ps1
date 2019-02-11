# Dischi da controllare: se impostato su $null o vuoto controlla tutti i dischi locali
# $drives = @("C","D");
$drives = $null;

# Dimensione minima per far scattare l'errore
$minSize = 20GB;

# configurazione SMTP: username, password & ecc.
$email_username = "username@yourdomain.com";
$email_password = "yourpassword";
$email_smtp_host = "smtp.yourdomain.com";
$email_smtp_port = 25;
$email_smtp_SSL = 0;
$email_from_address = "username@yourdomain.com";
$email_to_addressArray = @("to1@yourdomain.com", "to2@yourdomain.com");


if ($drives -eq $null -Or $drives -lt 1) {
	$localVolumes = Get-WMIObject win32_volume;
	$drives = @();
    foreach ($vol in $localVolumes) {
	    if ($vol.DriveType -eq 3 -And $vol.DriveLetter -ne $null ) {
  		    $drives += $vol.DriveLetter[0];
		}
	}
}
foreach ($d in $drives) {
	Write-Host ("`r`n");
	Write-Host ("Controllo disco " + $d + " ...");
	$disk = Get-PSDrive $d;
	if ($disk.Free -lt $minSize) {
		Write-Host ("Il disco " + $d + " ha meno di " + $minSize `
			+ " bytes liberi (" + $disk.free + "): invio e-mail...");
		
		$message = new-object Net.Mail.MailMessage;
		$message.From = $email_from_address;
		foreach ($to in $email_to_addressArray) {
			$message.To.Add($to);
		}
		$message.Subject = 	("[DiskLow] WARNING: " + $env:computername + " Il disco " + $d);
		$message.Subject +=	(" ha meno di " + $minSize + " bytes free ");
		$message.Subject +=	("(" + $disk.Free + ")");
		$message.Body =		"Attenzione, `r`n`r`n";
		$message.Body += 	"questo è un messaggio automatico ";
		$message.Body += 	"inviato dallo script Powershell DiskLow ";
		$message.Body += 	("per informarti che " + $env:computername + " il disco " + $d + " ");
		$message.Body += 	"sta terminando lo spazio a disposizione. `r`n`r`n";
		$message.Body += 	"--------------------------------------------------------------";
		$message.Body +=	"`r`n";
		$message.Body += 	("HostName: " + $env:computername + " `r`n");
		$message.Body += 	"IP Address(es): ";
		$ipAddresses = Get-NetIPAddress -AddressFamily IPv4;
		foreach ($ip in $ipAddresses) {
		    if ($ip.IPAddress -like "127.0.0.1") {
			    continue;
			}
		    $message.Body += ($ip.IPAddress + " ");
		}
		$message.Body += 	"`r`n";
		$message.Body += 	("Spazio utilizzato sul disco " + $d + ": " + $disk.Used + " bytes. `r`n");
		$message.Body += 	("Spazio libero sul disco " + $d + ": " + $disk.Free + " bytes. `r`n");
		$message.Body += 	"--------------------------------------------------------------";
		$message.Body +=	"`r`n`r`n";
		$message.Body += 	"Questo avviso si attiva quando lo spazio libero è più basso ";
		$message.Body +=	("di " + $minSize + " bytes `r`n`r`n");
	
               
		$smtp = new-object Net.Mail.SmtpClient($email_smtp_host, $email_smtp_port);
		$smtp.EnableSSL = $email_smtp_SSL;
		$smtp.Credentials = New-Object System.Net.NetworkCredential($email_username, $email_password);
		$smtp.send($message);
		$message.Dispose();
		write-host "... E-Mail inviata" ; 
	}
	else {
		Write-Host ("Il disco " + $d + " ha più di " + $minSize + " bytes liberi: OK ");
	}
}