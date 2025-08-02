# ------------------------------------------------------------------------------------
# Type: 		    Function
# Name: 		    Create-Browser
# Description:	    
# Parameters:		Selected browser
# Return Values:	
# Requirements:		Installed Browser Microsoft Edge, Google Chrome, Mozilla Firefox			
# ------------------------------------------------------------------------------------

function Create-Browser {
    param(
        [Parameter(mandatory=$true)]
        [ValidateSet("Chrome", "Edge", "Firefox")]
        [string] $Browser,
             
        [Parameter(mandatory=$false)]
        [bool] $HideCommandPrompt = $true,

        [Parameter(mandatory=$false)]
        [string] $driverversion = "",
        
        [Parameter(mandatory=$false)]
        [bool] $Headless = $true,

        [Parameter(mandatory=$false)]
        [string] $Proxy = "None",

        [Parameter(mandatory=$false)
        ][object]$options = $null
    )

    # 
    $driver = $null

    #
    function Load-NugetAssembly {
	    [CmdletBinding()]
	    param(
		    [string]$url,
		    [string]$name,
		    [string]$zipinternalpath,
		    [switch]$downloadonly
	    )

        #
        [string] $localpath = join-path ".\Selenium.WebDriver" $name


        #
	    $tmp = "$env:TEMP\$([IO.Path]::GetRandomFileName())"      
	    $zip = $null

        #
	    try{
		    if (! (Test-Path $localpath) ) {

                # Adds a Microsoft .NET class to a PowerShell session
			    Add-Type -AssemblyName System.IO.Compression.FileSystem

                # Textausgabe in der Konsole
			    Write-Host "Downloading and extracting required library '$name' ... " -F Green -NoNewline  
                
                #
			    (New-Object System.Net.WebClient).DownloadFile($url, $tmp)

                #
			    $zip = [System.IO.Compression.ZipFile]::OpenRead($tmp)

                #
			    $zip.Entries | Where-Object { $_.Fullname -eq $zipinternalpath } | ForEach-Object {

                    # Datei aus dem Archiv in das Zielverzeichnis kopieren. 
                    # Falls die Datei bereits vorhanden ist, wird diese überschrieben.
                    [System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, $localpath, "true")
			    }

                # Textausgabe in der Konsole
                Write-Host "OK" -F Green
                
		    }

            # Unblocks files that were downloaded from the internet 
		    if (Get-Item $localpath -Stream zone.identifier -ea SilentlyContinue) {
			    Unblock-File -Path $localpath
		    }

            # 
		    if (!$downloadonly.IsPresent) {

                # Adds a Microsoft .NET class to a PowerShell session
			    Add-Type -Path $localpath -ErrorAction Stop
		    }
              
	    }
        catch {
		    throw "Error: $($_.Exception.Message)"      
	    }
        finally {

            # Pruefe, ob das ZIP Archiv gefoeffnet ist
            # true:: schließe das Archiv
            # False: Tue nichts
		    if ($zip) {
                    $zip.Dispose()
            }

            # Pruefe, ob 
		    if (Test-Path -Path $tmp) {

                # Loesche das Objekt
                Remove-Item $tmp -Force -ErrorAction Stop
            }
	    }
    }

    # Load Selenium Webdriver .NET Assembly and dependencies
    Load-NugetAssembly 'https://www.nuget.org/api/v2/package/Newtonsoft.Json' -name 'Newtonsoft.Json.dll' -zipinternalpath 'lib/net45/Newtonsoft.Json.dll' -ErrorAction Stop    
    Load-NugetAssembly 'https://www.nuget.org/api/v2/package/Selenium.WebDriver/4.23.0' -name 'WebDriver.dll' -zipinternalpath 'lib/netstandard2.0/WebDriver.dll' -ErrorAction Stop    
    

    #
    [string] $driverpath = ".\Selenium.WebDriver"

    #
    switch ($browser) {

        'Chrome' {
            #    
            $chrome = Get-Package -Name "Google Chrome" -ErrorAction SilentlyContinue | Select-Object -First 1
            
            #
            if (!$chrome) {
                throw "Google Chrome Browser not installed."      
                return
            }

            #
            Load-NugetAssembly "https://www.nuget.org/api/v2/package/Selenium.WebDriver.ChromeDriver/$driverversion" -name 'chromedriver.exe' -zipinternalpath 'driver/win32/chromedriver.exe' -downloadonly -ErrorAction Stop
                  
            # Create driver service
            $dService = [OpenQA.Selenium.Chrome.ChromeDriverService]::CreateDefaultService($driverpath)

            # Hide command prompt window
            $dService.HideCommandPromptWindow = $HideCommandPrompt

            # Create driver options object
            #region
            $options = New-Object OpenQA.Selenium.Chrome.ChromeOptions

            # Start browser invisibly
            If($Headless) {
                $options.AddArgument("--headless")
            }
            #endregion

            # Create driver object
            $driver = New-Object OpenQA.Selenium.Chrome.ChromeDriver $dService,$options
        }

        'Edge' {      
            #
            $edge = Get-Package -Name "Microsoft Edge" -ErrorAction SilentlyContinue | Select-Object -First 1
            
            #
            if (!$edge) {
                throw "Microsoft Edge Browser not installed."      
                return
            }

            #
            Load-NugetAssembly "https://www.nuget.org/api/v2/package/Selenium.WebDriver.MSEdgeDriver.win32/$driverversion" -name 'msedgedriver.exe' -zipinternalpath 'driver/win32/msedgedriver.exe' -downloadonly -EA Stop  
               
            # Create driver service
            $dService = [OpenQA.Selenium.Edge.EdgeDriverService]::CreateDefaultService($driverpath)

            # Hide command prompt window
            $dService.HideCommandPromptWindow = $HideCommandPrompt

            # Create driver options object
            #region
            $options = New-Object OpenQA.Selenium.Edge.EdgeOptions

            # Start browser invisibly
            If($Headless) {
                $options.AddArgument("--headless")
            }
            #endregion

            # Create driver object
            $driver = New-Object OpenQA.Selenium.Edge.EdgeDriver $dService,$options
        }

        'Firefox' {     
            # 
            $ff = Get-Package -Name "Mozilla Firefox*" -ErrorAction SilentlyContinue | Select-Object -First 1

            #
            if (!$ff) {
                throw "Mozilla Firefox Browser not installed."
                return

            }

            #
            Load-NugetAssembly "https://www.nuget.org/api/v2/package/Selenium.WebDriver.GeckoDriver/$driverversion" -name 'geckodriver.exe' -zipinternalpath 'driver/win64/geckodriver.exe' -downloadonly -ErrorAction Stop    
              
            # Create driver service
            $dService = [OpenQA.Selenium.Firefox.FirefoxDriverService]::CreateDefaultService($driverpath)

            # Hide command prompt window
            $dService.HideCommandPromptWindow = $HideCommandPrompt

            # Create driver options object
            #region
            $options = New-Object OpenQA.Selenium.Firefox.FirefoxOptions

            # Start browser invisibly
            If ($Headless) {
                $options.AddArgument("--headless")
            }
            #rendregion


            # Create driver object
            $driver = New-Object OpenQA.Selenium.Firefox.FirefoxDriver $dService, $options
        }
    }

    # Return value to the main program
    return $driver
}