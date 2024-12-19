param (
    [string]$fileName
)

if (Test-Path $fileName) {
    try {
        # Calcola l'hash SHA256
        $sha256 = Get-FileHash -Path $fileName -Algorithm SHA256
        $hashValue = $sha256.Hash

        # Crea il nome del file di output
        $outputFileName = "$fileName.sha256"

        # Scrivi l'hash nel file di output
        Set-Content -Path $outputFileName -Value $hashValue

        # Messaggio di conferma in verde
        Write-Host "SHA256 hash calcolato e scritto in $outputFileName" -ForegroundColor Green
    } catch {
        # Messaggio di errore in rosso
        Write-Host "Errore nel calcolo dell'hash: $_" -ForegroundColor Red
    }
} else {
    # Messaggio di errore in rosso
    Write-Host "Il file $fileName non esiste." -ForegroundColor Red
}
