# Debug / Development Build Script (PowerShell)
# Reads .env and forwards variables as --dart-define to flutter run.
#
# Usage (from project root OR scripts/ folder):
#   .\scripts\build_debug.ps1                    -> flutter run (debug)
#   .\scripts\build_debug.ps1 -d <device-id>    -> run on specific device
#   .\scripts\build_debug.ps1 clean             -> flutter clean + pub get
#   .\scripts\build_debug.ps1 l10n              -> generate localisation
#   .\scripts\build_debug.ps1 test              -> run all tests
#   .\scripts\build_debug.ps1 release           -> build and run release on emulator/device
#   .\scripts\build_debug.ps1 release -d <id>  -> run release on specific device
#   .\scripts\build_debug.ps1 build             -> build release APK only (for sharing)

# Navigate to project root (one level up from scripts/)
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location (Join-Path $scriptDir "..")

$doRelease = $false
$doBuildOnly = $false

# Handle utility sub-commands
if ($args.Count -gt 0) {
    switch ($args[0]) {
        "clean" {
            Write-Host "Cleaning project..."
            flutter clean
            Write-Host "Fetching dependencies..."
            flutter pub get
            Write-Host "Clean complete."
            exit 0
        }
        "l10n" {
            Write-Host "Generating localisation files..."
            flutter gen-l10n
            Write-Host "Localisation files generated."
            exit 0
        }
        "test" {
            Write-Host "Running tests..."
            flutter test
            exit 0
        }
        "gen" {
            Write-Host "Running build_runner code generation..."
            dart run build_runner build --delete-conflicting-outputs
            Write-Host "Code generation complete."
            exit 0
        }
        "release" {
            $doRelease = $true
            break
        }
        "build" {
            $doBuildOnly = $true
            break
        }
    }
}

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
    Write-Warning ".env file not found - using defaults."
}

# Build --dart-define list
$defines = @()

foreach ($key in @("API_BASE_URL", "API_VERSION", "GOOGLE_SERVER_CLIENT_ID", "GOOGLE_CLIENT_SECRET", "SENTRY_DSN")) {
    if ($envVars.ContainsKey($key) -and $envVars[$key]) {
        $defines += "--dart-define=$key=$($envVars[$key])"
    }
}

# Summary
if ($doBuildOnly) {
    Write-Host "Building release APK..."
    Write-Host "   flutter build apk --release $($defines -join ' ')"
} elseif ($doRelease) {
    Write-Host "Building and running release on emulator/device..."
    Write-Host "   flutter run --release $($defines -join ' ')"
} else {
    Write-Host "Running: flutter run $($args -join ' ') $($defines -join ' ')"
}
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

# Run flutter
if ($doBuildOnly) {
    & flutter build apk --release @defines
    if ($LASTEXITCODE -eq 0) {
        $apkPath = "build\app\outputs\flutter-apk\app-release.apk"
        if (Test-Path $apkPath) {
            $fullPath = (Resolve-Path $apkPath).Path
            Write-Host ""
            Write-Host "Release APK built successfully:" -ForegroundColor Green
            Write-Host "   $fullPath"
        }
    }
} elseif ($doRelease) {
    $releaseArgs = $args | Where-Object { $_ -ne "release" }
    & flutter run --release @releaseArgs @defines
} else {
    & flutter run @args @defines
}

