Function CheckProc {
    param (
        [Parameter(Position=0)]
        [string]$ProcName
    )

    $CheckProc = Get-Process -Name $ProcName -ErrorAction SilentlyContinue
    if ($CheckProc) {
        return $True
    } else {
        return $False
    }
}