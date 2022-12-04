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
    $PuzzleInput
        | Where-Object {
            $ends = $_ -split ',' -split '-' | Sort-Object { [int]$_ }
            $_ -match "(^|,)$($ends[0])-$($ends[3])(,|$)"
        }
        | Measure-Object
        | Select-Object -ExpandProperty Count
}

function part2() {
    $PuzzleInput
        | Where-Object {
            $ends = $_ -split ',' -split '-' | Sort-Object { [int]$_ }
            $_ -match "(^|,)$($ends[0])-($($ends[2])|$($ends[3]))(,|$)"
        }
        | Measure-Object
        | Select-Object -ExpandProperty Count
}

& "part$Part"
