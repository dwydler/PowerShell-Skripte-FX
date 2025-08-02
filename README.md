# Beschreibung
Eine Sammlung von verschiedenen Funktionen in PowerShell, welche ich über die Jahre geschrieben habe. 
Funktionen die in gewisser Weise zusammengehören, habe ich in den jeweiligen Dateien zusammengefasst. 

# Rahmenbedingungen
Alle Funktionen sind mit PowerShell 5.1 kompatibel.

# Verwendung
Ich habe dieses Repository in meinen Skripten mit Hilfe von git submodules eingebunden. Dafür verwende ich in Skripten ein Verzeichnis mit dem Namen `PSFunctions`. 
Die Namen der Dateien sind so gewählt, dass diese in der korrekten Reihenweise eingebunden werden können.

Nachstehend der dazugehörige Code Schnipsel zum Nachladen der Dateien im Hauptskript:
```
# Load default functions from folder "PSFunctions"
Get-ChildItem -Path "$PSScriptRoot\PSFunctions" | Select-Object Name, Fullname | Sort-Object Name | ForEach-Object {

    # Load function of the particular file
    . $_.FullName
}
```

# Sonstiges
Bei Problemen und Fragen gerne ein Issue erstellen.
Verbesserungsvorschläge sind jederzeit herzlich Willkommen. Dazu gerne einen Pull Request erstellen.