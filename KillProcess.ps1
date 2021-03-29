Function KillProcess {
    Param($ProcName)

    $Proc = Get-Process $ProcName -ErrorAction SilentlyContinue

    if ($Proc) {
        Write-Log -type 4 -msg "Process: $ProcName was found - killing..."
        $Proc | Stop-Process -Force
    }
}