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
    simulateSand | Select-Object -ExpandProperty UnitsToReachFloor
}

function part2 {
    simulateSand | Select-Object -ExpandProperty Units
}

function simulateSand {
    $paths = $PuzzleInput | ForEach-Object { ,@($_ -split ',| -> ') }
    $height = $paths
        | ForEach-Object { for ($i = 1; $i -lt $_.Length; $i += 2) { $_[$i] } }
        | Measure-Object -Maximum
        | ForEach-Object { $_.Maximum + 2 }
    $width = 2 * $height - 1
    $xoffset = 500 - [System.Math]::Truncate($width / 2)
    $cells = [System.Collections.BitArray]::new($width * $height)
    foreach ($points in $paths) {
        for ($i = 2; $i -lt $points.Length; $i += 2) {
            $x0 = [int]$points[$i - 2] - $xoffset
            $y0 = [int]$points[$i - 1]
            $x1 = [int]$points[$i + 0] - $xoffset
            $y1 = [int]$points[$i + 1]
            if ($x1 -lt $x0) {
                $x0, $x1 = $x1, $x0
            }
            if ($y1 -lt $y0) {
                $y0, $y1 = $y1, $y0
            }
            for ($y = $y0; $y -le $y1; $y++) {
                for ($x = $x0; $x -le $x1; $x++) {
                    $cells[$y * $width + $x] = $true
                }
            }
        }
    }
    $unitsToReachFloor = $null
    :outer for ($units = 0; -not $cells[500 - $xoffset]; $units++) {
        $x = 500 - $xoffset
        for ($y = 1; $y -lt $height; $y++) {
            if ($cells[$y * $width + $x]) {
                $x--
                if ($cells[$y * $width + $x]) {
                    $x += 2
                    if ($cells[$y * $width + $x]) {
                        $x--
                        $cells[($y - 1) * $width + $x] = $true
                        continue outer
                    }
                }
            }
        }
        $unitsToReachFloor ??= $units
        $cells[($y - 1) * $width + $x] = $true
    }

    [pscustomobject]@{ UnitsToReachFloor = $unitsToReachFloor; Units = $units }
}

& "part$Part"
