function Measure-CopyPerformance {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true,ValueFromPipelinebyPropertyName = $true)]
        [Alias('Destination')]
        [ValidateNotNullOrEmpty()]
        [string] $Path,

        [Parameter()]
        [ValidateRange(0,[uint32]::MaxValue)]
        [uint32] $Size = 20MB
    )

    if (Test-Path -Path $Path) {
        
        $tmpFolder = [System.IO.Path]::GetTempPath()
        $tmpFileName = [System.IO.Path]::GetRandomFileName()
        $tmpFile = Join-Path -Path $tmpFolder -ChildPath $tmpFileName
        $destinationPath = Join-Path -Path $Path -ChildPath $tmpFileName

        New-File -Path $tmpFile -Size $Size
        
        try {

            $sendTest = Measure-Command {
                Copy-Item -Path $tmpFile -Destination $destinationPath -ErrorAction Stop
            }

            Remove-Item -Path $tmpFile -Force

            $receiveTest = Measure-Command {
                Copy-Item -Path $destinationPath -Destination $tmpFile -ErrorAction Stop
            }

            Remove-Item -Path $tmpFile -Force
            Remove-Item -Path $destinationPath -Force

            $sendMbps = [Math]::Round(((($Size * 8) / $sendTest.TotalSeconds) / 1000000),2)
            $receiveMbps = [Math]::Round(((($Size * 8) / $receiveTest.TotalSeconds) / 1000000),2)

            Write-Output ([PSCustomObject] [Ordered] @{
                Path = $Path
                SendMbps = $sendMbps
                ReceiveMbps = $receiveMbps
            })

        }
        catch {
            Write-Warning $_.Exception.Message
        }

    }

    else {
        Write-Warning "Unable to connect to $Path"
    }

}