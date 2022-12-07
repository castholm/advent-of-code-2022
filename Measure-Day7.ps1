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
    (getDirectorySizes $PuzzleInput).Values -le 100000 | Measure-Object -Sum | Select-Object -ExpandProperty Sum
}

function part2() {
    $sizes = getDirectorySizes $PuzzleInput
    $requiredSize = 30000000 - (70000000 - $sizes['/'])

    $sizes.Values -ge $requiredSize | Measure-Object -Minimum | Select-Object -ExpandProperty Minimum
}

function getDirectorySizes($lines) {
    $sizes = @{}
    $stack = [System.Collections.Generic.List[string]]::new()
    foreach ($line in $lines) {
        if ($line -match '^\$ cd (.+)$') {
            if ($Matches.1 -eq '/') {
                $stack.Clear()
            } elseif ($Matches.1 -eq '..') {
                $stack.RemoveAt($stack.Count - 1)
            } else {
                $stack.Add($Matches.1)
            }
        } elseif ($line -match '^(\d+) .+$') {
            $sizes['/'] += [int]$Matches.1
            $path = ''
            foreach ($segment in $stack) {
                $path += '/' + $segment
                $sizes[$path] += [int]$Matches.1
            }
        }
    }

    $sizes
}

& "part$Part"
