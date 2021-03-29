Function ValidateParam {
    param(
        [Parameter(Position=0)]
        [string]$Switch,
        [Parameter(Position=1)]
        [string[]]$ValArr,
        [Parameter(Position=2)]
        [string]$propName
    )

    $pass = 0

    ForEach ($item in $ValArr) {
        if ($Switch -eq $item) {
            $pass++
        }
    }

    if ($Pass -eq 0) {
        Write-Log -type 2 -msg "Error: Wrong $($propName) argument was selected. Available options: $($ValArr)."
        $ErrCode = 8
		$isSuccess = $False
        $StatusDesc = "Error: Wrong $($propName) argument was selected. Available options: $($ValArr)."
        EndLog
        exit $ErrCode
    }
}