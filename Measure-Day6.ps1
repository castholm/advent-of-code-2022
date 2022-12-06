#Requires -Version 7.3

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateRange(1, 2)]
    [int] $Part,

    [Parameter(Mandatory = $true)]
    [AllowEmptyCollection()]
    [AllowEmptyString()]
    [string] $PuzzleInput
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 3.0

function part1() {
    [regex]::Match($PuzzleInput, (createPattern 4)).Index + 4
}

function part2() {
    [regex]::Match($PuzzleInput, (createPattern 14)).Index + 14
}

function createPattern($length) {
    1..($length - 1) | Join-String { "(.)(?!$(1..$_ -replace '.+', '\$_' -join '|'))" } -OutputSuffix '.'
}

& "part$Part"
