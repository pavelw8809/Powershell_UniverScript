Function Write-Log {
    Param(
        [Parameter(Position=0, Mandatory=$True)]
        [string]$msg,
        [Parameter(Position=1)]
        [ValidateSet(0, 1, 2, 3, 4, 5, 6)]
        [int]$Type = 0,
        [Parameter(Position=2)]
        [string]$LogFolder = "$Env:SystemDrive/logs",
        [Parameter(Position=3)]
        [string]$lTW = $LogPath
    )

        $Timestamp = Get-Date -Format "MM-dd-yyyy_HH.mm:ss"

        switch($type) {
            0 {
                $msg = "$Timestamp - $Msg"
                Write-Host $msg
            }
            1 {
                $msg = "$Timestamp - [WARNING] - $msg"
                Write-Host $msg -ForegroundColor yellow
            }
            2 {
                $msg = "$Timestamp - [ERROR] - $msg"
                Write-Host $msg -ForegroundColor red
            }
            3 {
                $msg = "$Timestamp - [SUCCESS] - $msg"
                Write-Host $msg -ForegroundColor green
            }
            4 {
                $msg = "$Timestamp - [INFO] - $msg"
                Write-Host $msg -ForegroundColor white
            }
            5 {
                $msg = "$Msg"
                Write-Host $msg -ForegroundColor cyan
            }
            6 {
                $msg = "$Msg"
                Write-Host $msg -ForegroundColor yellow
            }
        }

        Add-Content -Path $lTW -Value $msg
}
