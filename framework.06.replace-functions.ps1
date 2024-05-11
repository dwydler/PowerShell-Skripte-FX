# -----------------------------------------------------------------------------
# Type: 		    Function
# Name: 		    ReplaceBatchVariables
# Description:	    Translates batch variables to PowerShell variables
# Parameters:		batch variable name
# Return Values:	powershell variable name
# Requirements:					
# -----------------------------------------------------------------------------
function ReplaceBatchVariables {
    param (
        [parameter(Position=0)]
        [string] $StringPath
    )

    # Replace all batch variables
    if ($StringPath -match "%ALLUSERSPROFILE%") {
        $StringPath = $StringPath.Replace("%ALLUSERSPROFILE%", "$env:ALLUSERSPROFILE")
    }
    elseif ($StringPath -match "%windir%") {
        $StringPath = $StringPath.Replace("%windir%", "$env:windir")
    }
    elseif ($StringPath -match "%SystemRoot%") {
        $StringPath = $StringPath.Replace("%SystemRoot%", "$env:systemroot")
    }
    elseif ($StringPath -match "%PROGRAMFILES%") {
        $StringPath = $StringPath.Replace("%PROGRAMFILES%", "$env:PROGRAMFILES")
    }
    elseif ($StringPath -match "%ProgramData%") {
        $StringPath = $StringPath.Replace("%ProgramData%", "$env:ProgramData")
    }

    return $StringPath
}


# -----------------------------------------------------------------------------
# Type: 		    Function
# Name: 		    ReplaceUmlaute
# Description:	    Replace all Umlaute and Leerzeichen with Hashtable
# Parameters:		Textstring
# Return Values:	
# Requirements:					
# -----------------------------------------------------------------------------
function ReplaceUmlaute {
    param (
        [Parameter(Mandatory=$True)]
        [string] $strText
    )


    # create HashTable with replace map
    $characterMap = @{}
    $characterMap.([Int][Char]'ä') = "ae"
    $characterMap.([Int][Char]'ö') = "oe"
    $characterMap.([Int][Char]'ü') = "ue"
    $characterMap.([Int][Char]'ß') = "ss"
    $characterMap.([Int][Char]'Ä') = "Ae"
    $characterMap.([Int][Char]'Ü') = "Ue"
    $characterMap.([Int][Char]'Ö') = "Oe"
    $characterMap.([Int][Char]'ß') = "ss"
    
    # Replace chars
    ForEach ($key in $characterMap.Keys) {
        $strText = $strText -creplace ([Char]$key),$characterMap[$key] 
    }
 
    # return result
    $strText
}