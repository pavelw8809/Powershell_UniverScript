Function EndLog {

    if ($ErrCode -eq 0) {
        $isSuccess = $True
        $StatusDesc = "Script was completed successfully"
    }

    if ($isSuccess -eq $True) {
        $Status = "SUCCESS"
    } else {
        $Status = "ERROR"
    }

    Write-Log -type 5 -msg " "
    Write-Log -type 5 -msg "F I N A L   R E S U L T :"
    Write-Log -type 5 -msg "$($br)"
    Write-Log -type 5 -msg "SCRIPT COMPLETED WITH $Status"
    Write-Log -type 5 -msg "ERROR CODE: $ErrCode"
    Write-Log -type 5 -msg "DESCRIPTION: $StatusDesc"
    Write-Log -type 5 -msg "$($br)"
    Write-Log -type 5 -msg " "
}