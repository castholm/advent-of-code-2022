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

# Somehow this horrific brute force approach for part 2 yielded the correct answer in only a litte over an hour...
# I won't clean up the code because that would require running the script again to verify everything still works.

$ycheck = 2000000

function part1 {
    $ranges = [System.Collections.Generic.List[hashtable]]::new()
    $beaconx = [System.Collections.Generic.HashSet[int]]::new()
    foreach ($line in $PuzzleInput) {
        $null = $line -match '^Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)$'
        $sx, $sy, $bx, $by = [int]$Matches.1, [int]$Matches.2, [int]$Matches.3, [int]$Matches.4
        $radius = [System.Math]::Abs($sx - $bx) + [System.Math]::Abs($sy - $by) + 1
        $yy = [System.Math]::Abs($sy - $ycheck) + 1
        $diff = $radius - $yy
        if ($diff -ge 0) {
            $ranges.Add(@{ Start = $sx - $diff; End = $sx + $diff })
        }
        if ($by -eq $ycheck) {
            $null = $beaconx.Add($bx)
        }
    }
    $ranges.Sort([System.Comparison[hashtable]]{ param ($a, $b) $a.Start.CompareTo($b.Start) })
    for ($i = 0; $i -lt $ranges.Count - 1; $i++) {
        if ($ranges[$i + 1].Start -le $ranges[$i].End) {
            $ranges[$i].End = [System.Math]::Max($ranges[$i].End, $ranges[$i + 1].End)
            $ranges.RemoveAt($i + 1)
            $i--
        }
    }
    $sum = $ranges
        | ForEach-Object { $_.End - $_.Start + 1 }
        | Measure-Object -Sum
        | Select-Object -ExpandProperty Sum

    $sum - $beaconx.Count
}

function part2 {
    $signals = [System.ValueTuple[int, int, int][]]$(
        foreach ($line in $PuzzleInput) {
            $null = $line -match '^Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)$'
            $sx, $sy, $bx, $by = [int]$Matches.1, [int]$Matches.2, [int]$Matches.3, [int]$Matches.4
            $radius = [System.Math]::Abs($sx - $bx) + [System.Math]::Abs($sy - $by) + 1

            [System.ValueTuple[int, int, int]]::new($sx, $sy, $radius)
        }
    )
    $i = 0
    :outer while ($true) {
        $x = 0
        $y = 2000000 + $i
        :inner while ($x -lt 4000000) {
            for ($j = 0; $j -lt $signals.Length; $j++) {
                $current = $signals[$j]
                $rrr = [System.Math]::Abs($current.Item1 - $x) + [System.Math]::Abs($current.Item2 - $y) + 1
                if ($rrr -le $current.Item3) {
                    $x += $current.Item3 - $rrr + 1
                    continue inner
                }
            }
            break outer
        }
        $i = -bnot $i
        $x = 0
        $y = 2000000 + $i
        :inner while ($x -lt 4000000) {
            for ($j = 0; $j -lt $signals.Length; $j++) {
                $current = $signals[$j]
                $rrr = [System.Math]::Abs($current.Item1 - $x) + [System.Math]::Abs($current.Item2 - $y) + 1
                if ($rrr -le $current.Item3) {
                    $x += $current.Item3 - $rrr + 1
                    continue inner
                }
            }
            break outer
        }
        $i = -$i
        if (($i -band 255) -eq 0) {
            $pp = [int][System.Math]::Truncate([System.Math]::Abs($i) / 2000000 * 100)
            Write-Progress -Activity 'Searching' -status "$pp% complete ($(2 * $i) iterations)" -PercentComplete $pp
        }
    }

    $x * 4000000 + $y
}

& "part$Part"
