$hyperlink = "https://download-installer.cdn.mozilla.net/pub/firefox/releases/133.0.3/win64/it/Firefox%20Setup%20133.0.3.exe"
$installOptions = "/silent"


function Download-And-Execute {
    param (
        [string]$hyperlink,
        [string]$installOptions
    )
    $fileName = [System.Uri]::UnescapeDataString(($hyperlink -split '/')[-1])
    $downloadDirectory = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('UserProfile'), 'Downloads')
    $filePath = [System.IO.Path]::Combine($downloadDirectory, $fileName)
    if (-Not (Test-Path -Path $filePath)) {
        Write-Host "Il file non esiste. Inizio il download..." -ForegroundColor Yellow
        $webClient = New-Object System.Net.WebClient
        $webClient.DownloadFile($hyperlink, $filePath)
    }
    Write-Host "Eseguo il file..." -ForegroundColor Green
    if ($installOptions) {
        $process = Start-Process -FilePath $filePath -ArgumentList $installOptions -Wait -PassThru
    } else {
        $process = Start-Process -FilePath $filePath -Wait -PassThru
    }
    if ($process.ExitCode -eq 0) {
        Write-Host "Operazione completata con successo! Cancello il file..." -ForegroundColor Green
        Remove-Item -Path $filePath
    } else {
        Write-Host "Operazione fallita con codice di uscita $($process.ExitCode)." -ForegroundColor Red
    }
}
Download-And-Execute -hyperlink $hyperlink -installOptions $installOptions
