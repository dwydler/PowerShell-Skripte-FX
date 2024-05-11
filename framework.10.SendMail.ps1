Function SendMail {
    param (
        [Parameter(Mandatory=$True,Position=1)]
        [string] $MailServerName,

        [Parameter(Mandatory=$False,Position=2)]
        [int] $MailServerPort = 25,

        [Parameter(Mandatory=$True,Position=3)]
        [string] $EmailAbsender,

        [Parameter(Mandatory=$True,Position=4)]
        [string] $EmailEmpfaenger,

        [Parameter(Mandatory=$True,Position=5)]
        [string] $EmailSubject,

        [Parameter(Mandatory=$True,Position=6)]
        [string] $EmailBody,

        [Parameter(Mandatory=$False)]
        [bool] $Tls = $false,

        [Parameter(Mandatory=$False)]
        [string] $MailServerAuthUser,

        [Parameter(Mandatory=$False)]
        [string] $EmailAttachment
    )


    # Neues Objekt
    $oSmtpClient = New-Object System.Net.Mail.SmtpClient($MailServerName, $MailServerPort)
    $oSmtpMessage = New-Object System.Net.Mail.MailMessage($EmailAbsender, $EmailEmpfaenger, $EmailSubject, $EmailBody)

    # (De)aktivert TLS
    $oSmtpClient.EnableSSL = $Tls

    # Prüft ob ein Benutzer angegeben wurde
    if($MailServerAuthUser) {
        
        # Prüfe, ob das cmdlet PSCredential geladen ist
        if ( Get-Command Get-PSCredential -ErrorAction SilentlyContinue) {

            # Output
            Write-Host "Das cmdlet PSCredential wurde eingebunden." -ForegroundColor Green

            #Prüft ob für den angegeben Credentials vorhanden sind und fragt ggf. nach dem Passwort
            $oSmtpClient.Credentials = Get-PSCredential "$MailServerAuthUser"
        }
        else {
            return Write-host "Das cmdlet PSCredential konnte nicht gefunden werden!" -ForegroundColor Red
        }
    }

    # Attach Attachments
    if ($EmailAttachment) {
        $oSmtpMessageAttachment = New-Object System.Net.Mail.Attachment("$EmailAttachment")
        $oSmtpMessage.Attachments.Add($oSmtpMessageAttachment)
    }
    # E-Mail verschicken
    try {
        Write-Host "`nE-Mail wird versendet..."
        $oSmtpClient.Send($oSmtpMessage)
        return Write-Host "E-Mail wurde verschickt." -ForegroundColor Green
    }
    catch [exception] {
        Write-Host $("Fehler: " + $_.Exception.GetType().FullName) -ForegroundColor Red
        Write-Host $("Fehler: " + $_.Exception.Message + "`n") -ForegroundColor Red
    }
}

