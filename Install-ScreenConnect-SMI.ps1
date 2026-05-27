
# Install-ScreenConnect.ps1
# Downloads and installs the ScreenConnect client (Vision Tech Group - SMI)

$url = "https://cmd-visiontechgrpllc.screenconnect.com/Bin/ScreenConnect.ClientSetup.msi?e=Access&y=Guest&c=SMI&c=&c=&c=&c=&c=&c=&c="
$downloadPath = "$env:TEMP\ScreenConnect.ClientSetup.msi"

Write-Host "Downloading ScreenConnect client..." -ForegroundColor Cyan

try {
    # Use TLS 1.2
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    # Download the MSI
    Invoke-WebRequest -Uri $url -OutFile $downloadPath -UseBasicParsing

    if (Test-Path $downloadPath) {
        Write-Host "Download complete: $downloadPath" -ForegroundColor Green
        Write-Host "Installing ScreenConnect client..." -ForegroundColor Cyan

        # Install silently
        $installArgs = "/i `"$downloadPath`" /quiet /norestart"
        $process = Start-Process -FilePath "msiexec.exe" -ArgumentList $installArgs -Wait -PassThru

        if ($process.ExitCode -eq 0) {
            Write-Host "Installation completed successfully." -ForegroundColor Green
        } else {
            Write-Host "Installation exited with code: $($process.ExitCode)" -ForegroundColor Yellow
        }
    } else {
        Write-Host "Download failed - file not found." -ForegroundColor Red
    }
} catch {
    Write-Host "Error: $_" -ForegroundColor Red
} finally {
    # Clean up the installer
    if (Test-Path $downloadPath) {
        Remove-Item $downloadPath -Force
        Write-Host "Cleaned up installer file." -ForegroundColor Gray
    }
}
