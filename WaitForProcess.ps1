Function WaitForProcess {
    param(
        [Parameter(Position=0)]
        [string]$Proc,
        [Parameter(Position=1)]
        [string]$TimeOut=3600
    )

    $sec = 0

    do {
        $CheckProcess = Get-Process -Name $Proc -ErrorAction SilentlyContinue
        $time = MinuteFormat $sec
        Write-Log -type 5 -msg "Waiting for process: $($Proc) - time: $($time)"
        Start-Sleep -s 5
        $sec = $sec+5
    }
    while ($CheckProcess -and ($sec -lt $TimeOut))
}