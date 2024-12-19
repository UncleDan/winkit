param(
    [Parameter(Mandatory=$true)]
    [string]$folderPath
)

# Controlla se la cartella esiste
if (-not (Test-Path -Path $folderPath -PathType Container)) {
    Write-Host "La cartella specificata non esiste: $folderPath" -ForegroundColor Red
    return
}

# Ottieni il nome della cartella
$folderName = Split-Path $folderPath -Leaf

# Percorso del file di output
$outputFilePath = Join-Path -Path $folderPath -ChildPath "$folderName.sha256.txt"

# Rimuovi il file di output se esiste giÃ 
if (Test-Path $outputFilePath) {
    Remove-Item $outputFilePath
}

# Ottieni tutti i file nella cartella
$files = Get-ChildItem -Path $folderPath -File -Recurse

# Ordina i file per sottocartella e nome del file
$sortedFiles = $files | Sort-Object { $_.DirectoryName }, { $_.Name }

foreach ($file in $sortedFiles) {
    # Calcola l'hash SHA256 del file
    $hash = Get-FileHash -Path $file.FullName -Algorithm SHA256

    # Ottieni il percorso relativo del file
    $relativePath = $file.FullName.Replace($folderPath, '')

    # Scrivi l'hash e il percorso relativo del file nel file di output
    "$($hash.Hash) $relativePath" | Out-File -FilePath $outputFilePath -Append
}