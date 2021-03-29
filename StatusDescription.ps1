Function StatusDescription {
    Param (
        [Parameter(Position=0)]
        [string]$AppName,
        [Parameter(Position=1)]
        [int]$ErrVal
    )

    $StatusArr = @(
        (0,     "$($AppName) software was installed successfully"),
        (259,   "$($AppName) software was installed successfully - REBOOT IS REQUIRED!"),
        (1605,  "$($AppName) software is already installed!"),
        (1641,  "$($AppName) software was installed successfully - REBOOT IS REQUIRED!"),
        (3010,  "$($AppName) software was installed successfully - REBOOT IS REQUIRED!"),
        (5,     "$($AppName) installation failed"),
        (1602,  "$($AppName) installation was interrupted by user"),
        (1603,  "$($AppName) installation failed - FATAL ERROR 1603. Review the msi log."),
        (1618,  "ERROR_INSTALL_ALREADY_RUNNING - Other msi installation already in progress. Check and kill all msiexec processes."),
        (1619,  "ERROR_INSTALL_PACKAGE_OPEN_FAILED - Installation file could not be open. Check paths to installation file, transform or log"),
        (1622,  "ERROR_INSTALL_LOG_FAILURE - Verify if log folder exists and the log path"),
        (1624,  "ERROR_INSTALL_TRANSFORM_FAILURE - Verify transform path"),
        (1633,  "ERROR_INSTALL_PLATFORM_UNSUPPORTED - The msi file was created for other OS platform (32/64bit)"),
        (1639,  "ERROR_INVALID_COMMAND_LINE - Invalid command or the newer version of the software is already installed.")
    )

    $errSum = $StatusArr.Length
    $e = 0
    $knownError = $False

    if ($ErrVal -eq 800) {
        $FInfo = "Ret. code: 0: The $($AppName) is already installed"
        Write-Log -type 1 -msg "$($FInfo)"
        return $script:StatusDesc = $FInfo
        return $script:ErrVal = 0
    } elseif ($ErrVal -eq 801) {
        $FInfo = "Ret. code: 0: The $($AppName) is already uninstalled"
        Write-Log -type 1 -msg "$($FInfo)"
        return $script:StatusDesc = $FInfo
        return $script:ErrVal = 0
        Write-Log -type 4 -msg "Ret. code: $($StatusArr[$e][0]): $($StatusArr[$e][1])"
        return $script:StatusDesc = $item[1]
    } else {
        While($e -lt $errSum) {
            #Write-Log "$($StatusArr[$e][0]) : $($ErrVal)"
            if($StatusArr[$e][0] -eq $ErrVal) {
                Write-Log -type 4 -msg "Ret. code: $($StatusArr[$e][0]): $($StatusArr[$e][1])"
                $knownError = $True
                return $script:StatusDesc = $StatusArr[$e][1] 
            }
            $e = $e+1
        }
        if ($knownError -eq $False) {
            Write-Log -type 4 -msg "Ret. code: $($ErrVal): Undefined error. Check installation log file if exists."
            return $script:StatusDesc = "Ret. code: $($ErrVal): Undefined error. Check installation log file if exists."
        }
    }
}