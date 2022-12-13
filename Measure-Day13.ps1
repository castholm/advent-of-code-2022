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
    $(
        for (($i = 0), ($j = 1); $i -lt $PuzzleInput.Length; ($i += 3), ($j++)) {
            $a = @(ConvertFrom-Json $PuzzleInput[$i + 0])
            $b = @(ConvertFrom-Json $PuzzleInput[$i + 1])

            $j * ((comparePackets $a $b) -lt 0)
        }
    ) | Measure-Object -Sum | Select-Object -ExpandProperty Sum
}

function part2 {
    $packets = ($PuzzleInput + '[[2]]' + '[[6]]') | ForEach-Object { $_ ? ,@(ConvertFrom-Json $_) : @() }
    [array]::Sort($packets, [System.Comparison[object]]$Function:comparePackets)
    $div1 = [array]::FindIndex($packets, [System.Predicate[object]]{ param ($x) -not (comparePackets $x 2L) }) + 1
    $div2 = [array]::FindIndex($packets, [System.Predicate[object]]{ param ($x) -not (comparePackets $x 6L) }) + 1

    $div1 * $div2
}

function comparePackets ($a, $b) {
    if ($a -isnot [array] -and $b -isnot [array]) {
        return $a.CompareTo($b)
    }
    $a = @($a)
    $b = @($b)
    $length = [System.Math]::Min($a.Length, $b.Length)
    for ($i = 0; $i -lt $length; $i++) {
        $c = comparePackets $a[$i] $b[$i]
        if ($c -ne 0) {
            return $c
        }
    }
    return $a.Length.CompareTo($b.Length)
}

& "part$Part"
