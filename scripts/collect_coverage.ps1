<#
.SYNOPSIS
    Run Flutter tests with coverage and produce coverage/lcov.info.

.EXAMPLE
    .\scripts\collect_coverage.ps1
#>

[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$RepoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
Set-Location $RepoRoot

Write-Host 'Running flutter test --coverage...' -ForegroundColor Cyan
flutter test --coverage

$coverageDir = Join-Path $RepoRoot 'coverage'
$lcovPath = Join-Path $coverageDir 'lcov.info'

if (-not (Test-Path $lcovPath)) {
    Write-Error "Expected $lcovPath was not created."
    exit 1
}

Write-Host "LCOV report: $lcovPath" -ForegroundColor Green

# Optional: format with coverage package (same as dart-collect-coverage skill)
if (Get-Command dart -ErrorAction SilentlyContinue) {
    Write-Host 'Formatting coverage (check-ignore)...' -ForegroundColor Cyan
    dart run coverage:format_coverage `
        --packages="$RepoRoot\.dart_tool\package_config.json" `
        --lcov `
        -i "$coverageDir\lcov.info" `
        -o $lcovPath `
        --check-ignore
}

Write-Host 'Done.' -ForegroundColor Green
