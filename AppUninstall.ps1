<#
.SYNOPSIS
    Function: AppUninstall

.DESCRIPTION
    EXTENDED NAME:
    Main uninstall function (with checking if the software is installed)

    DESCRIPTION:
    Main uninstall function for all installers/processes
    Takes uninstall arguments, checking if the software is installed and run InstallCMD function.

.PARAMETER GUID
    Name of key in HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall (GUID or App regkey)

.PARAMETER App
    Path to main process:
    - full path to main uninstall exe file
    - msiexec.exe - in case of msi installers

.PARAMETER AppArgs
    Argumets to uninstall command.
    - All uninstall switches

.PARAMETER AppName
    Name of the software in string
    - Used for logging and installation logname.

.PARAMETER Time
    (OPTIONAL PARAMETER)
    Default: 60 minutes
    Timeout for the installation (in minutes).

.EXAMPLE
    Run msi uninstallation with default timeout of 60 minutes
    AppUninstall -GUID 

.EXAMPLE
    Run uninstall exe with timeout extended to 120 minutes
    AppUninstall -GUID "SAPGUI" -App "C:\Program Files (x86)\SAP\SAPsetup\setup\NwSapSetup.exe" -AppArgs " /uninstall /quiet" -AppName "SAP GUI For Windows 7.40" -Time 120
    AppUninstall "SAPGUI" "C:\Program Files (x86)\SAP\SAPsetup\setup\NwSapSetup.exe" "/uninstall /quiet" "SAP GUI For Windows 7.40" 120

.EXAMPLE
    $UninstallGUID = "{26A24AE4-039D-4CA4-87B4-2F32180201F0}"
    AppUninstall -GUID $UninstallGUID -App "msiexec.exe" -AppArgs "/x $UninstallGUID /qn /l*v "C:\O-I\logs\JavaJRE_8.0.201_uninstall.log"" -AppName "Java JRE u8u201"
    AppUninstall $UninstallGUID "msiexec.exe" "/x $UninstallGUID /qn /l*v "C:\O-I\logs\JavaJRE_8.0.201_uninstall.log"" "Java JRE u8u201"

.NOTES
    PREREQUISITES:
    1) InstallCMD
    2) StatusDescription
    3) Logging function

    REVISION HISTORY:
        ver. 1.00 - 15/01/2020 - Initial version
#>

Function AppUninstall {
    param (
        [Parameter(Position=0)]
        [string]$GUID,
        [Parameter(Position=1)]
        [string]$App,
        [Parameter(Position=2)]
        [string]$AppArgs,
        [Parameter(Position=3)]
        [string]$AppName,
        [Parameter(Position=4)]
        [int]$Time = 60
    )

    $Reg64 = Test-Path -LiteralPath "HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$GUID"
    $Reg32 = Test-Path -LiteralPath "HKLM:SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\$GUID"
    
    if($Reg64 -Or $Reg32) {
        Write-Log -type "info" -msg "Start $AppName uninstallation"
        InstallCMD -Proc $App -Args $AppArgs -AppName $AppName -Time $Time
        if(!($isSuccess)) {
            EndLog
            Set-Strictmode -Off
            exit $ErrVal
        }
    } else {
        StatusDescription $AppName 801 
        return $script:isSuccess = $True
    }
}

# --- PREREQUISITES --- #

Function InstallCMD {
	Param(
		[Parameter(Position=0)]
		[string]$Proc,
		[Parameter(Position=1)]
		[string]$Args,
		[Parameter(Position=2)]
		[string]$AppName,
		[Parameter(Position=3)]
		[int[]]$RetCodeList = @(0, 259, 1605, 1641, 259),
		[Parameter(Position=4)]
		[int]$Time = 60
	)
	
	$TimeOut = $Time * 60

	Write-Log -type "info" -msg "Running Command: $Proc $Args, process time-out: $TimeOut seconds"
	$Process = (Start-Process -FilePath $dbq$Proc$dbq -ArgumentList $Args -windowstyle Hidden -PassThru)
	
	Try {
		$Process | Wait-Process -Timeout $TimeOut -ErrorAction Stop
        Write-Log -type "info" -msg "Completed with return code: $($Process.ExitCode)"

		if ($RetCodeList -contains $Process.ExitCode) {
			$script:isSuccess = $True
            StatusDescription $AppName $Process.ExitCode
        } else {
            $script:isSuccess = $False
            StatusDescription $AppName $Process.ExitCode
		}
			
        return $script:ErrCode = $Process.ExitCode
		return $script:isSuccess
	}
	Catch {
        $ErrMsg = $_.Exception.Message
        $StatusDesc = "Error description: $($ErrMsg) - script line: ($($_.InvocationInfo.ScriptLineNumber)), command name: ($($_.InvocationInfo.InvocationName))"
        $ErrCode = 300
        EndLog
		$procID = $Process.Id.ToString()
		killProcess $procID
		exit 300
	}	
}

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
        (1605,  "$($AppName) software is already installed/uninstalled!"),
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
        Write-Log -type "warning" -msg "$($FInfo)"
        return $script:StatusDesc = $FInfo
        return $script:ErrVal = 0
    } elseif ($ErrVal -eq 801) {
        $FInfo = "Ret. code: 0: The $($AppName) is already uninstalled"
        Write-Log -type "warning" -msg "$($FInfo)"
        return $script:StatusDesc = $FInfo
        return $script:ErrVal = 0
        #Write-Log -type "info" -msg "Ret. code: $($StatusArr[$e][0]): $($StatusArr[$e][1])"
        #return $script:StatusDesc = $item[1]
    } elseif ($ErrVal -eq 802) {
        $FInfo = "Ret. code: 0: GUID $($AppName) was not found"
        Write-Log -type "info" -msg "$($FInfo)"
        return $script:StatusDesc = $FInfo
        return $script:ErrVal = 0
    } else {
        While($e -lt $errSum) {
            #Write-Log "$($StatusArr[$e][0]) : $($ErrVal)"
            if($StatusArr[$e][0] -eq $ErrVal) {
                Write-Log -type "info" -msg "Ret. code: $($StatusArr[$e][0]): $($StatusArr[$e][1])"
                $knownError = $True
                return $script:StatusDesc = $StatusArr[$e][1] 
            }
            $e = $e+1
        }
        if ($knownError -eq $False) {
            Write-Log -type "info" -msg "Ret. code: $($ErrVal): Undefined error. Check installation log file if exists."
            return $script:StatusDesc = "Ret. code: $($ErrVal): Undefined error. Check installation log file if exists."
        }
    }
}