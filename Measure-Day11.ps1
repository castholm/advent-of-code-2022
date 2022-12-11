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

function part1 {
    getMonkeyBusinessLevel 20 3
}

function part2 {
    getMonkeyBusinessLevel 10000 0
}

function getMonkeyBusinessLevel ([long] $rounds, [long] $relief) {
    $monkeys = for ($i = 0; $i -lt $PuzzleInput.Length; $i += 7) {
        @{
            Items = [System.Collections.Generic.Queue[long]][long[]]($PuzzleInput[$i + 1].Substring(18) -split ', ')
            Op = $PuzzleInput[$i + 2][23]
            Arg = $PuzzleInput[$i + 2].Substring(25) -eq 'old' ? $null : [long]$PuzzleInput[$i + 2].Substring(25)
            Inspections = 0
            Test = [long]$PuzzleInput[$i + 3].Substring(21)
            Next = @{
                $true = [long]$PuzzleInput[$i + 4].Substring(29)
                $false = [long]$PuzzleInput[$i + 5].Substring(30)
            }
        }
    }
    $lcd = multiplyAll ($monkeys | Select-Object -ExpandProperty Test)
    for ($round = 0; $round -lt $rounds; $round++) {
        foreach ($monkey in $monkeys) {
            while ($monkey.Items.Count -gt 0) {
                $item = $monkey.Items.Dequeue()
                if ($monkey.Op -eq '+') {
                    $item += $monkey.Arg ?? $item
                } else {
                    $item *= $monkey.Arg ?? $item
                }
                $monkey.Inspections++
                if ($relief -ne 0) {
                    $item = [long][System.Math]::Truncate($item / $relief)
                } else {
                    $item %= $lcd
                }
                $monkeys[$monkey.Next[$item % $monkey.Test -eq 0]].Items.Enqueue($item)
            }
        }
    }

    multiplyAll ($monkeys | Sort-Object Inspections -Top 2 -Descending | Select-Object -ExpandProperty Inspections)
}

function multiplyAll ([long[]] $values) {
    $total = 1L
    foreach ($value in $values) {
        $total *= $value
    }

    $total
}

& "part$Part"
