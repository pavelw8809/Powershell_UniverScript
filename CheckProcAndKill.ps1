Function CheckProcAndKill {
    param (
        [Parameter(Position=0)]
        [string]$ProcName,
        [Parameter(Position=1)]
        [int]$Interval = 5,
        [Parameter(Position=2)]
        [int]$Timeout = 600
    )

    $t = 0

	do {
        $ElapsedTime = MinuteFormat $t
        $FinishTime = MinuteFormat $Timeout
        $CheckProc = Get-Process -Name $ProcName -ErrorAction SilentlyContinue
        Write-Host $CheckProc
        if ($CheckProc) {
            KillProcess $ProcName
            $e = 1
        } else {
            $e = 0
        }
		Write-Log -type 4 -msg "Waiting for process to kill $($ProcName) - time: $($ElapsedTime)/$($FinishTime)"
		$t = $t+$Interval
		Start-Sleep -s $Interval
	} while (($t -le $Timeout) -and ($e -eq 0))
}