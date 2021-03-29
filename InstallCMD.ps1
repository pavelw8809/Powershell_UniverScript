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

	Write-Log -type 4 -msg "Running Command: $Proc $Args, process time-out: $TimeOut seconds"
	$Process = (Start-Process -FilePath $dbq$Proc$dbq -ArgumentList $Args -windowstyle Hidden -PassThru)
	
	Try {
		$Process | Wait-Process -Timeout $TimeOut -ErrorAction Stop
        Write-Log -type 4 -msg "Completed with return code: $($Process.ExitCode)"

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