#Requires -Version 7.3

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateRange(1, 2)]
    [int] $Part,

    [Parameter(Mandatory = $true)]
    [AllowEmptyCollection()]
    [AllowEmptyString()]
    [string[]] $PuzzleInput
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 3.0

function part1() {
    $PuzzleInput -join ';' -split ';;'
        | ForEach-Object { $_ -split ';' | Measure-Object -Sum }
        | Measure-Object Sum -Maximum
        | Select-Object -ExpandProperty Maximum
}

function part2() {
    $PuzzleInput -join ';' -split ';;'
        | ForEach-Object { $_ -split ';' | Measure-Object -Sum }
        | Sort-Object Sum -Top 3 -Descending
        | Measure-Object Sum -Sum
        | Select-Object -ExpandProperty Sum
}

& "part$Part"
