function New-File {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $Path,

        [Parameter()]
        [ValidateRange(0,[uint32]::MaxValue)]
        [uint32] $Size = 0
    )

    try {
        $fs = New-Object -TypeName System.IO.FileStream -ArgumentList ($Path, [System.IO.FileMode]::CreateNew)
        $fs.SetLength($Size)
    }
    catch {
        Write-Warning $_.Exception.Message
    }
    finally {
        $fs.Close()
    }
}