# PSBenchmark
# Authors: Jan Egil Ring & Øyvind Kallstad

Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Functions') | ForEach-Object {
    . $_.FullName
}