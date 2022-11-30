#Requires -Version 7.3

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateRange(1, 25)]
    [int] $Day
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 3.0

$appDataDir = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::ApplicationData)
$file = Join-Path $appDataDir "castholm/advent-of-code-2022/$Day.txt"
if (-not (Test-Path -LiteralPath $file)) {
    if (-not $env:ADVENT_OF_CODE_SESSION) {
        throw 'ADVENT_OF_CODE_SESSION is not set.'
    }
    $null = New-Item $file -Force
    $webSession = [Microsoft.PowerShell.Commands.WebRequestSession]::new()
    $webSession.Cookies.Add([System.Net.Cookie]::new(
        'session',
        $env:ADVENT_OF_CODE_SESSION,
        '/',
        '.adventofcode.com'
    ))
    Invoke-WebRequest "https://adventofcode.com/2022/day/$Day/input" -WebSession $webSession -OutFile $file
}

Get-Content -LiteralPath $file
