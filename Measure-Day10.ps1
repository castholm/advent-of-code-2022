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
    $script:sum = 0
    foreachCycle {
        if (($cycle + 21) % 40 -eq 0) {
            $script:sum += ($cycle + 1) * $x
        }
    }

    $sum
}

function part2 {
    $screen = [System.Collections.BitArray]::new(240)
    foreachCycle {
        $screen[$cycle] = [System.Math]::Abs(($cycle % 40) - $x) -le 1
    }

    @{ $false = '.'; $true = '#' }[$screen] -join '' -replace '.{40}(?!$)', '$&;' -split ';'
}

function foreachCycle ([scriptblock]$action) {
    $cycle = 0
    $x = 1
    foreach ($instruction in $PuzzleInput) {
        $cost, $operand = 1, 0
        if ($instruction -match '^\w+ (-?\d+)$') {
            $cost, $operand = 2, [int]$Matches.1
        }
        for ($i = 0; $i -lt $cost; $i++) {
            & $action
            $cycle++
        }
        $x += $operand
    }
}

& "part$Part"
