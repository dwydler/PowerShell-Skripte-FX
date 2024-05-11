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
# Name: 		    HumanReadableByteSize
# Description:	    Converts a storage space size into the largest possible unit
# Parameters:		
# Return Values:	integer
# Requirements:					
# -----------------------------------------------------------------------------
function HumanReadableByteSize {

    param (
        [Parameter(Mandatory, Position=0)]
        [ValidateNotNullOrEmpty()]
        [int64] $SizeinBytes
    )


    switch ($SizeinBytes) {
	    { $_ -gt 1TB } { ($SizeinBytes / 1TB).ToString("n2") + " TB"; break}
	    { $_ -gt 1GB } { ($SizeinBytes / 1GB).ToString("n2") + " GB"; break}
	    { $_ -gt 1MB } { ($SizeinBytes / 1MB).ToString("n2") + " MB"; break}
	    { $_ -gt 1KB}  { ($SizeinBytes / 1KB).ToString("n2") + " KB"; break}
	    default {"$SizeinBytes B"}
	}
}