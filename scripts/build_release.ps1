# Secure Release Build Script (PowerShell)
# Obfuscated release build with env vars passed as --dart-define.
#
# Usage (from project root OR scripts/ folder):
#   .\scripts\build_release.ps1 apk          -> Build release APK
#   .\scripts\build_release.ps1 appbundle    -> Build release App Bundle (Play Store)
#   .\scripts\build_release.ps1 ios          -> Build release iOS
#   .\scripts\build_release.ps1 apk --flavor prod -t lib/main_prod.dart
#   .\scripts\build_release.ps1 apk --no-clean -> Skip cleaning for faster rebuilds
#
# All extra flags after the platform are forwarded to flutter build.
# Use --no-clean to skip flutter clean and Gradle daemon stop (faster rebuilds).
#
# Env vars (loaded from .env if present):
#   API_BASE_URL
#   API_VERSION
#   GOOGLE_SERVER_CLIENT_ID
#   GOOGLE_CLIENT_SECRET

# Navigate to project root (one level up from scripts/)
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location (Join-Path $scriptDir "..")

$platform = if ($args.Count -gt 0) { $args[0] } else { "apk" }
$extraArgs = if ($args.Count -gt 1) { $args[1..($args.Count - 1)] } else { @() }

$symbolsDir = "build/symbols"
New-Item -ItemType Directory -Force -Path $symbolsDir | Out-Null

# Load .env file
$envFile = ".env"
$envVars = @{}

if (Test-Path $envFile) {
    Get-Content $envFile | ForEach-Object {
        $line = $_.Trim()
        if ($line -and -not $line.StartsWith("#")) {
            $parts = $line -split "=", 2
            if ($parts.Count -eq 2) {
                $key = $parts[0].Trim()
                $value = $parts[1].Trim()
                $envVars[$key] = $value
            }
        }
    }
}
if (-not (Test-Path $envFile)) {
    Write-Warning ".env file not found - using environment variables or defaults."
}

# â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
# Clean previous build (skip with --no-clean flag)
# â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
$skipClean = $extraArgs -contains "--no-clean"
if ($skipClean) {
    $extraArgs = $extraArgs | Where-Object { $_ -ne "--no-clean" }
    Write-Host "Skipping clean (--no-clean flag detected)" -ForegroundColor Yellow
} else {
    Write-Host "Cleaning previous build artifacts..." -ForegroundColor Cyan
    
    # Stop Gradle daemon to release file locks
    $gradlewPath = Join-Path $PSScriptRoot "..\android\gradlew.bat"
    if (Test-Path $gradlewPath) {
        Write-Host "  Stopping Gradle daemon..." -ForegroundColor Gray
        Push-Location (Join-Path $PSScriptRoot "..\android")
        & .\gradlew.bat --stop 2>$null
        Pop-Location
    }
    
    # Clean Flutter build
    Write-Host "  Running flutter clean..." -ForegroundColor Gray
    & flutter clean
    
    # Get dependencies
    Write-Host "  Running flutter pub get..." -ForegroundColor Gray
    & flutter pub get
    
    Write-Host "Clean complete!" -ForegroundColor Green
    Write-Host ""
}

# Build --dart-define list
$defines = @()

foreach ($key in @("API_BASE_URL", "API_VERSION", "GOOGLE_SERVER_CLIENT_ID", "GOOGLE_CLIENT_SECRET", "SENTRY_DSN")) {
    if ($envVars.ContainsKey($key) -and $envVars[$key]) {
        $defines += "--dart-define=$key=$($envVars[$key])"
    }
}

# Summary
Write-Host "Building SECURE release ($platform) with obfuscation..."
if ($envVars.ContainsKey('API_BASE_URL') -and $envVars['API_BASE_URL']) {
    Write-Host "   API_BASE_URL = $($envVars['API_BASE_URL'])"
} else {
    Write-Host "   API_BASE_URL = <not set>"
}
if ($envVars.ContainsKey('API_VERSION') -and $envVars['API_VERSION']) {
    Write-Host "   API_VERSION  = $($envVars['API_VERSION'])"
} else {
    Write-Host "   API_VERSION  = <not set>"
}
Write-Host ""

switch ($platform) {
    "apk" {
        & flutter build apk --release `
            --obfuscate `
            "--split-debug-info=$symbolsDir" `
            @defines @extraArgs
        if ($LASTEXITCODE -eq 0) {
            $apkPath = "build\app\outputs\flutter-apk\app-release.apk"
            if (Test-Path $apkPath) {
                $fullPath = (Resolve-Path $apkPath).Path
                Write-Host ""
                Write-Host "APK ready at: $fullPath" -ForegroundColor Green
            }
        }
    }
    "appbundle" {
        & flutter build appbundle --release `
            --obfuscate `
            "--split-debug-info=$symbolsDir" `
            @defines @extraArgs
        if ($LASTEXITCODE -eq 0) {
            Write-Host ""
            Write-Host "App Bundle ready at: build\app\outputs\bundle\release\app-release.aab" -ForegroundColor Green
        }
    }
    "ios" {
        & flutter build ios --release `
            --obfuscate `
            "--split-debug-info=$symbolsDir" `
            @defines @extraArgs
        if ($LASTEXITCODE -eq 0) {
            Write-Host ""
            Write-Host "iOS build ready." -ForegroundColor Green
        }
    }
    default {
        Write-Host "Unknown platform: $platform" -ForegroundColor Red
        Write-Host "   Usage: .\scripts\build_release.ps1 [apk|appbundle|ios] [extra flutter flags...]"
        exit 1
    }
}

Write-Host "Debug symbols saved to $symbolsDir (keep for crash reports)"

