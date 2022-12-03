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
        | ForEach-Object {
            $x = $_[0..($_.Length / 2 - 1)]
                | Compare-Object $_[($_.Length / 2)..($_.Length - 1)] -CaseSensitive -ExcludeDifferent -PassThru
                | Select-Object -Unique
            getPriority $x
        }
        | Measure-Object -Sum
        | Select-Object -ExpandProperty Sum
}

function part2() {
    $PuzzleInput
        | ForEach-Object -Begin { $i = 0 } -Process {
            @{ GroupIndex = [int][System.Math]::Truncate($i++ / 3); Value = [char[]]$_ }
        }
        | Group-Object GroupIndex
        | ForEach-Object {
            $x = $_.Group[0].Value
                | Compare-Object $_.Group[1].Value -CaseSensitive -ExcludeDifferent -PassThru
                | Compare-Object $_.Group[2].Value -CaseSensitive -ExcludeDifferent -PassThru
                | Select-Object -Unique
            getPriority $x
        }
        | Measure-Object -Sum
        | Select-Object -ExpandProperty Sum
}

function getPriority($x) {
    [char]$x - ([char]$x -ge [char]'a' ? [char]'`' : [char]'&')
}

& "part$Part"
