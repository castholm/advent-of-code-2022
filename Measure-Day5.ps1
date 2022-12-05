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
    $sepIndex = $PuzzleInput.IndexOf('')
    $stacks = parseStacks $PuzzleInput[0..($sepIndex - 2)]

    for ($lineIndex = $sepIndex + 1; $lineIndex -lt $PuzzleInput.Length; $lineIndex++) {
        $null = $PuzzleInput[$lineIndex] -match 'move (\d+) from (\d) to (\d)'
        for ($i = 0; $i -lt $Matches.1; $i++) {
            $stacks[$Matches.3 - 1].Push($stacks[$Matches.2 - 1].Pop())
        }
    }

    popJoin $stacks
}

function part2() {
    $sepIndex = $PuzzleInput.IndexOf('')
    $stacks = parseStacks $PuzzleInput[0..($sepIndex - 2)]

    $tempStack = [System.Collections.Generic.Stack[string]]::new()
    for ($lineIndex = $sepIndex + 1; $lineIndex -lt $PuzzleInput.Length; $lineIndex++) {
        $null = $PuzzleInput[$lineIndex] -match 'move (\d+) from (\d) to (\d)'
        for ($i = 0; $i -lt $Matches.1; $i++) {
            $tempStack.Push($stacks[$Matches.2 - 1].Pop())
        }
        while ($tempStack.Count -gt 0) {
            $stacks[$Matches.3 - 1].Push($tempStack.Pop())
        }
    }

    popJoin $stacks
}

function parseStacks($lines) {
    $stacks = [System.Collections.Generic.Stack[string][]]::new(9)
    for ($i = 0; $i -lt $stacks.Length; $i++) {
        $stacks[$i] = [System.Collections.Generic.Stack[string]]::new()
    }
    for ($lineIndex = $lines.Length - 1; $lineIndex -ge 0; $lineIndex--) {
        $line = $PuzzleInput[$lineIndex]
        for (($i = 0), ($boxIndex = 1); $boxIndex -lt $line.Length; $i++, ($boxIndex += 4)) {
            $boxValue = $line[$boxIndex]
            if ($boxValue -ne ' ') {
                $stacks[$i].Push($boxValue)
            }
        }
    }

    $stacks
}

function popJoin($stacks) {
    (& {
        foreach ($stack in $stacks) {
            if ($stack.Count -gt 0) {
                $stack.Pop()
            }
        }
    }) -join ''
}

& "part$Part"
