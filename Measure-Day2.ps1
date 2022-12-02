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
    $lut = @{ 'A X' = 4; 'A Y' = 8; 'A Z' = 3; 'B X' = 1; 'B Y' = 5; 'B Z' = 9; 'C X' = 7; 'C Y' = 2; 'C Z' = 6 }

    $lut[$PuzzleInput] | Measure-Object -Sum | Select-Object -ExpandProperty Sum
}

function part2() {
    $lut = @{ 'A X' = 3; 'A Y' = 4; 'A Z' = 8; 'B X' = 1; 'B Y' = 5; 'B Z' = 9; 'C X' = 2; 'C Y' = 6; 'C Z' = 7 }

    $lut[$PuzzleInput] | Measure-Object -Sum | Select-Object -ExpandProperty Sum
}

& "part$Part"
