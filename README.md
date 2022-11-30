## Usage

Requires PowerShell 7.3.

```powershell
# Set the ADVENT_OF_CODE_SESSION environment variable to the value of
# your session cookie on adventofcode.com.
$env:ADVENT_OF_CODE_SESSION = '...'

# Get your input for the given day.
$puzzleInput = ./Get-PuzzleInput.ps1 -Day 1

# Output your answers to both parts of that day's puzzle.
./Measure-Day1.ps1 -Part 1 $puzzleInput
./Measure-Day1.ps1 -Part 2 $puzzleInput
```
