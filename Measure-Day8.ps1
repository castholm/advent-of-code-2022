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

$height = $PuzzleInput.Length
$width = $PuzzleInput[0].Length
$treeHeights = [int[]]($PuzzleInput -split '(?<!^)(?!$)')

function part1() {
    $visible = [System.Collections.BitArray]::new($treeHeights.Length)
    for ($y = 0; $y -lt $height; $y++) {
        $max, $rmax = -1, -1
        for ($x = 0; $x -lt $width; $x++) {
            # Left
            $i = $y * $height + $x
            if ($treeHeights[$i] -gt $max) {
                $max = $treeHeights[$i]
                $visible[$i] = $true
            }
            # Right
            $i = $y * $height + ($width - 1 - $x)
            if ($treeHeights[$i] -gt $rmax) {
                $rmax = $treeHeights[$i]
                $visible[$i] = $true
            }
        }
    }
    for ($x = 0; $x -lt $height; $x++) {
        $max, $rmax = -1, -1
        for ($y = 0; $y -lt $height; $y++) {
            # Up
            $i = $y * $height + $x
            if ($treeHeights[$i] -gt $max) {
                $max = $treeHeights[$i]
                $visible[$i] = $true
            }
            # Down
            $i = ($height - 1 - $y) * $height + $x
            if ($treeHeights[$i] -gt $rmax) {
                $rmax = $treeHeights[$i]
                $visible[$i] = $true
            }
        }
    }

    $visible -eq $true | Measure-Object | Select-Object -ExpandProperty Count
}

function part2() {
    $visible = [hashtable[]]($treeHeights | ForEach-Object { @{} })
    $counts = [int[]]::new(10)
    $rcounts = [int[]]::new(10)
    for ($y = 0; $y -lt $height; $y++) {
        $counts.Clear()
        $rcounts.Clear()
        for ($x = 0; $x -lt $width; $x++) {
            # Left
            $i = $y * $height + $x
            $treeHeight = $treeHeights[$i]
            $visible[$i].L = $counts[$treeHeight]
            for ($j = 0; $j -le $treeHeight; $j++) {
                $counts[$j] = 1
            }
            for (; $j -lt 10; $j++) {
                $counts[$j]++
            }
            # Right
            $i = $y * $height + ($width - 1 - $x)
            $treeHeight = $treeHeights[$i]
            $visible[$i].R = $rcounts[$treeHeight]
            for ($j = 0; $j -le $treeHeight; $j++) {
                $rcounts[$j] = 1
            }
            for (; $j -lt 10; $j++) {
                $rcounts[$j]++
            }
        }
    }
    for ($x = 0; $x -lt $height; $x++) {
        $counts.Clear()
        $rcounts.Clear()
        for ($y = 0; $y -lt $height; $y++) {
            # Up
            $i = $y * $height + $x
            $treeHeight = $treeHeights[$i]
            $visible[$i].U = $counts[$treeHeight]
            for ($j = 0; $j -le $treeHeight; $j++) {
                $counts[$j] = 1
            }
            for (; $j -lt 10; $j++) {
                $counts[$j]++
            }
            # Down
            $i = ($height - 1 - $y) * $height + $x
            $treeHeight = $treeHeights[$i]
            $visible[$i].D = $rcounts[$treeHeight]
            for ($j = 0; $j -le $treeHeight; $j++) {
                $rcounts[$j] = 1
            }
            for (; $j -lt 10; $j++) {
                $rcounts[$j]++
            }
        }
    }

    $visible
        | ForEach-Object { $_.L * $_.R * $_.U * $_.D }
        | Measure-Object -Maximum
        | Select-Object -ExpandProperty Maximum
}

& "part$Part"
