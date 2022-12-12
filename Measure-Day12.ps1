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
$cells = [int[]][char[]]($PuzzleInput -split '(?<!^)(?!$)')
$start = $cells.IndexOf([int][char]'S')
$end = $cells.IndexOf([int][char]'E')
$cells[$start] = [int][char]'a'
$cells[$end] = [int][char]'z'

function part1 {
    findShortestPath $start $end
}

function part2 {
    findShortestPath (0..($cells.Length - 1) | Where-Object { $cells[$_] -eq [int][char]'a' }) $end
}

function findShortestPath ([int[]] $starts, [int] $end) {
    $shortest = [int[]]::new($cells.Length)
    [array]::Fill($shortest, [int]::MaxValue)
    $queue = [System.Collections.Generic.Queue[System.ValueTuple[int, int, int]]]::new()
    foreach ($start in $starts) {
        $x = $start % $width
        $y = [int][System.Math]::Truncate($start / $width)
        $queue.Enqueue([System.ValueTuple[int, int, int]]::new($x, $y, 0))
    }
    while ($queue.Count -ne 0) {
        $current = $queue.Dequeue()
        $x, $y, $steps = $current.Item1, $current.Item2, $current.Item3
        if ($steps -lt $shortest[$y * $width + $x]) {
            $shortest[$y * $width + $x] = $steps
            $elevation = $cells[$y * $width + $x]
            if ($x - 1 -ge 0 -and $cells[$y * $width + $x - 1] -le $elevation + 1) {
                $queue.Enqueue([System.ValueTuple[int, int, int]]::new($x - 1, $y, $steps + 1))
            }
            if ($x + 1 -lt $width -and $cells[$y * $width + $x + 1] -le $elevation + 1) {
                $queue.Enqueue([System.ValueTuple[int, int, int]]::new($x + 1, $y, $steps + 1))
            }
            if ($y - 1 -ge 0 -and $cells[($y - 1) * $width + $x] -le $elevation + 1) {
                $queue.Enqueue([System.ValueTuple[int, int, int]]::new($x, $y - 1, $steps + 1))
            }
            if ($y + 1 -lt $height -and $cells[($y + 1) * $width + $x] -le $elevation + 1) {
                $queue.Enqueue([System.ValueTuple[int, int, int]]::new($x, $y + 1, $steps + 1))
            }
        }
    }

    $shortest[$end]
}

& "part$Part"
