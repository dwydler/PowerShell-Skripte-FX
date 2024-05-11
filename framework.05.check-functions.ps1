# -----------------------------------------------------------------------------
# Type: 		    Function
# Name: 		    CheckModule
# Description:	    Checks, if the module exists on the system and loaded
# Parameters:		module name
# Return Values:	
# Requirements:					
# -----------------------------------------------------------------------------
Function CheckModule {
    param (
        [Parameter(Mandatory=$True)]
        [string] $Name
    )

	if(-not (Get-Module -name $name) ) {
		if(Get-Module -ListAvailable | Where-Object { $_.name -eq $name }) {
			Import-Module -Name $name
            write-host "Module $name ist bereits geladen." -ForegroundColor Green
		}
		else { 
            write-host "Module $name nicht gefunden!" -ForegroundColor Red
            pause
            exit
		}
	}
	else {
		write-host "Module $name ist geladen." -ForegroundColor Green
	}
}


# -----------------------------------------------------------------------------
# Type: 		    Function
# Name: 		    CheckSnapIn
# Description:	    Checks, if the Snapin is registered and loaded.
# Parameters:		snapin name
# Return Values:	
# Requirements:					
# -----------------------------------------------------------------------------
function CheckSnapIn {
    param (
        [Parameter(Mandatory=$True)]
        [string] $Name
    )

    if (get-pssnapin $name -ea "silentlycontinue") {
        write-host "PSsnapin $name ist bereits geladen." -ForegroundColor Green
    }
    elseif (get-pssnapin $name -registered -ea "silentlycontinue") {
        Add-PSSnapin $name
        write-host "PSsnapin $name ist geladen." -ForegroundColor Green
    }
    else {
        write-host "PSSnapin $name nicht gefunden!" -ForegroundColor Red
        pause
        exit
    }
}

# -----------------------------------------------------------------------------
# Type: 		    Function
# Name: 		    Test-IsAdmin
# Description:	    Checks whether the user is an administrator on the system
# Parameters:		
# Return Values:	True/False
# Requirements:					
# -----------------------------------------------------------------------------
function Check-IsAdmin {
    ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
}


# -----------------------------------------------------------------------------
# Type: 		    Function
# Name: 		    Get-UnusedDriveLetter
# Description:	    Translates batch variables to PowerShell variables
# Parameters:		
# Return Values:	Returns the first free drive letter
# Requirements:					
# -----------------------------------------------------------------------------
function Get-UnusedDriveLetter {
	
    #
    Param (
		[Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
		[switch] $AsString = $false
	)

    # Determine all single-letter drive names.
    [array] $aTakenDriveLetters = (Get-PSDrive).Name -like '?'


    # Find the first unused drive letter.
    [char] $chFirstUnusedDriveLetter = [char[]] (0x41..0x5a) | Where-Object { $_ -notin $aTakenDriveLetters } | Select-Object -first 1

    #
    if ($AsString -eq $true) {
        return $chFirstUnusedDriveLetter.ToString()
    }
    else {
        return $chFirstUnusedDriveLetter
    }
}


# -----------------------------------------------------------------------------
# Type: 		    Function
# Name: 		    Set-WorkingDir
# Description:	    
# Parameters:		
# Return Values:	
# Requirements:					
# -----------------------------------------------------------------------------
function Set-WorkingDir {
    param (
         [parameter(
            Mandatory=$false,
            Position=0
          )]
        [switch] $Debugging
    )

    # Splittet aus dem vollständigen Dateipfad den Verzeichnispfad heraus
    # Beispiel: D:\Daniel\Temp\Unbenannt2.ps1 -> D:\Daniel\Temp
    [string] $strWorkingdir = Split-Path $MyInvocation.PSCommandPath -Parent

    # Wenn Variable wahr ist, gebe Text aus.
    if ($Debugging) {
        Write-Host "[DEBUG] PS $strWorkingdir`>" -ForegroundColor Gray
    }

    # In das Verzeichnis wechseln
    Set-Location $strWorkingdir
}


# -----------------------------------------------------------------------------
# Type: 		    Function
# Name: 		    Check-IsIPv4Address
# Description:	    Checks whether the specified string is an IPv4 address
# Parameters:		Presumed IPv4 address
# Return Values:	True/False
# Requirements:					
# -----------------------------------------------------------------------------
function Check-IsIPv4Address ($ip) {
    return ($ip -match "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$" -and [bool]($ip -as [ipaddress]))
}