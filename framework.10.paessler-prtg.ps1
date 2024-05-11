# -----------------------------------------------------------------------------
# Type: 		    Function
# Name: 		    Set-PrtgError
# Description:	    
# Parameters:		
# Return Values:	Output of data in XML schema for PRTG to enter error status
# Requirements:					
# -----------------------------------------------------------------------------
function Set-PrtgError {
	Param (
		[Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
		[string]$PrtgErrorText
	)
	
    $strXmlOutput = "<prtg>`n"
    $strXmlOutput += "`t<error>1</error>`n"
    $strXmlOutput += "`t<text>$PrtgErrorText</text>`n"
    $strXmlOutput += "</prtg>"

    # Output Xml
    $strXmlOutput

    exit
}


# -----------------------------------------------------------------------------
# Type: 		    Function
# Name: 		    Set-PrtgSensorStatus
# Description:	    
# Parameters:		
# Return Values:	Output of data in XML schema for PRTG to set the defined status
# Requirements:					
# -----------------------------------------------------------------------------
function Set-PrtgSensorStatus {
	Param (
        [Parameter(mandatory=$true)]
        [ValidateSet('OK','Warning','Critical','Unkown')]
        [string]$ServiceStatus,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
		[string]$StatusText
	)
	
    # Declare variables
    [int] $intServiceStatusCode = 0

    # Evaluation of the status
    # Source: https://nagios-plugins.org/doc/guidelines.html#AEN78
    switch ($ServiceStatus) {
        "OK"       { $intServiceStatusCode = 0 }
        "Warning"  { $intServiceStatusCode = 1 }
        "Critical" { $intServiceStatusCode = 2 }
        "Unkown"   { $intServiceStatusCode = 3 }
    }

    ### Generate XML output for Paessler PRTG
    #region
    $strXmlOutput = "<prtg>`n"
    $strXmlOutput += "`t<error>$intServiceStatusCode</error>`n"
    $strXmlOutput += "`t<text>$StatusText</text>`n"
    $strXmlOutput += "</prtg>"

    # Output the contents of the variable
    $strXmlOutput
    #endregion

    exit
}


# -----------------------------------------------------------------------------
# Type: 		    Function
# Name: 		    Set-PrtgResult
# Description:	    
# Parameters:		
# Return Values:	Output of data in XML schema for PRTG
# Requirements:					
# -----------------------------------------------------------------------------
function Set-PrtgResult {
    Param (
        [Parameter(mandatory=$True,Position=0)]
        [string]$Channel,
    
        [Parameter(mandatory=$True,Position=1)]
        $Value,
    
        [Parameter(mandatory=$True,Position=2)]
        [string]$Unit,

        [Parameter(mandatory=$False)]
        [alias('mw')]
        [string]$MaxWarn,

        [Parameter(mandatory=$False)]
        [alias('minw')]
        [string]$MinWarn,
    
        [Parameter(mandatory=$False)]
        [alias('me')]
        [string]$MaxError,

        [Parameter(mandatory=$False)]
        [alias('mine')]
        [string]$MinError,
    
        [Parameter(mandatory=$False)]
        [alias('wm')]
        [string]$WarnMsg,
    
        [Parameter(mandatory=$False)]
        [alias('em')]
        [string]$ErrorMsg,
    
        [Parameter(mandatory=$False)]
        [alias('mo')]
        [string]$Mode,
    
        [Parameter(mandatory=$False)]
        [alias('sc')]
        [switch]$ShowChart,
    
        [Parameter(mandatory=$False)]
        [alias('ss')]
        [ValidateSet('One','Kilo','Mega','Giga','Tera','Byte','KiloByte','MegaByte','GigaByte','TeraByte','Bit','KiloBit','MegaBit','GigaBit','TeraBit')]
        [string]$SpeedSize,

        [Parameter(mandatory=$False)]
        [ValidateSet('One','Kilo','Mega','Giga','Tera','Byte','KiloByte','MegaByte','GigaByte','TeraByte','Bit','KiloBit','MegaBit','GigaBit','TeraBit')]
        [string]$VolumeSize,
		
		# Veeam Backup & Replication / Job Monitoring
		[Parameter(mandatory=$False)]
        [ValidateSet('Second','Minute','Hour','Day')]
        [string]$SpeedTime,
    
        [Parameter(mandatory=$False)]
        [alias('dm')]
        [ValidateSet('Auto','All')]
        [string]$DecimalMode,
    
        [Parameter(mandatory=$False)]
        [alias('w')]
        [switch]$Warning,
    
        [Parameter(mandatory=$False)]
        [string]$ValueLookup
    )
    
    $StandardUnits = @('BytesBandwidth','BytesMemory','BytesDisk','Temperature','Percent','TimeResponse','TimeSeconds','Custom','Count','CPU','BytesFile','SpeedDisk','SpeedNet','TimeHours')
    $LimitMode = $false
    
    $Result  = "`t<result>`n"
    $Result += "`t`t<channel>$Channel</channel>`n"
    $Result += "`t`t<value>$Value</value>`n"
    
    if ($StandardUnits -contains $Unit) {
        $Result += "`t`t<unit>$Unit</unit>`n"
    }
    elseif ($Unit) {
        $Result += "`t`t<unit>custom</unit>`n"
    $Result += "`t`t<customunit>$Unit</customunit>`n"
    }
    
    if (!($Value -is [int])) { $Result += "`t`t<float>1</float>`n" }
    if ($Mode)               { $Result += "`t`t<mode>$Mode</mode>`n" }
    if ($MaxWarn)            { $Result += "`t`t<limitmaxwarning>$MaxWarn</limitmaxwarning>`n"; $LimitMode = $true }
    if ($MinWarn)            { $Result += "`t`t<limitminwarning>$MinWarn</limitminwarning>`n"; $LimitMode = $true }
    if ($MaxError)           { $Result += "`t`t<limitmaxerror>$MaxError</limitmaxerror>`n"; $LimitMode = $true }
    if ($MinError)           { $Result += "`t`t<limitminerror>$MinError</limitminerror>`n"; $LimitMode = $true }
    if ($WarnMsg)            { $Result += "`t`t<limitwarningmsg>$WarnMsg</limitwarningmsg>`n"; $LimitMode = $true }
    if ($ErrorMsg)           { $Result += "`t`t<limiterrormsg>$ErrorMsg</limiterrormsg>`n"; $LimitMode = $true }
    if ($LimitMode)          { $Result += "`t`t<limitmode>1</limitmode>`n" }
    if ($SpeedSize)          { $Result += "`t`t<speedsize>$SpeedSize</speedsize>`n" }
    if ($VolumeSize)         { $Result += "`t`t<volumesize>$VolumeSize</volumesize>`n" }
    if ($SpeedTime)			 { $Result += "`t`t<speedtime>$SpeedTime</speedtime>`n" }	
    if ($DecimalMode)        { $Result += "`t`t<decimalmode>$DecimalMode</decimalmode>`n" }
    if ($Warning)            { $Result += "`t`t<warning>1</warning>`n" }
    if ($ValueLookup)        { $Result += "`t`t<ValueLookup>$ValueLookup</ValueLookup>`n" }
    if (!($ShowChart))       { $Result += "`t`t<showchart>0</showchart>`n" }
    
    $Result += "`t</result>`n"
    
    return $Result
}
