Function StartLog {
    Write-Log -type 6 -msg "M A I N   I N F O R M A T I O N"
    Write-Log -type 6 -msg "$($br)"
    Write-Log -type 6 -msg "Computer Name:       $Env:COMPUTERNAME"
    Write-Log -type 6 -msg "UniversalScript Ver: $($USVer)"
    Write-Log -type 6 -msg "Script Name:         $($ScriptName)"
    Write-Log -type 6 -msg "Source directory:    $($WorkDir)"
    Write-Log -type 6 -msg "$($br)"
    Write-Log -type 6 -msg " "
    Write-Log -type 0 -msg "Script starting..."
    Write-Log -type 6 -msg " "
    Write-Log -type 6 -msg "S C R I P T   L O G G I N G"
    Write-Log -type 6 -msg "$($br)"
}