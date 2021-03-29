Function KillService {
    param($ServiceName)

    $sctool = join-path -path $env:SystemRoot -childpath "System32\sc.exe"

    Write-Log -type 4 -msg "Deleting service: $ServiceName"
    Start-Process -FilePath $sctool -ArgumentList "delete $ServiceName"
}