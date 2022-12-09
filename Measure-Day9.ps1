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
    simulateRopes 2
}

function part2 {
    simulateRopes 10
}

function simulateRopes ([int] $knots) {
    $x = [int[]]::new($knots)
    $y = [int[]]::new($knots)
    $visited = [System.Collections.Generic.HashSet[System.ValueTuple[int, int]]]::new()
    foreach ($motion in $PuzzleInput) {
        $null = $motion -match '^(.) (\d+)$'
        $x1, $y1 = switch ($Matches.1) {
            'L' { -1;  0 }
            'R' { +1,  0 }
            'U' {  0; -1 }
            'D' {  0; +1 }
        }
        $steps = [int]$Matches.2
        for ($i = 0; $i -lt $steps; $i++) {
            $x[0] += $x1
            $y[0] += $y1
            for ($j = 1; $j -lt $knots; $j++) {
                $dx = $x[$j - 1] - $x[$j]
                $dy = $y[$j - 1] - $y[$j]
                if ([System.Math]::Abs($dx) -gt 1 -or [System.Math]::Abs($dy) -gt 1) {
                    $x[$j] += [System.Math]::Sign($dx)
                    $y[$j] += [System.Math]::Sign($dy)
                }
            }
            $null = $visited.Add([System.ValueTuple[int, int]]::new($x[$knots - 1], $y[$knots - 1]))
        }
    }

    $visited.Count
}

& "part$Part"
