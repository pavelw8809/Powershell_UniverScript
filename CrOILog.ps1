Function CrOILog {
    Param(
        [Parameter(Position=0)]
        [string]$LogName = $ScriptName
    )

    $OIFld = Join-Path -Path $Env:SystemDrive -ChildPath "O-I"
    $OILogs = Join-Path -Path $OIFld -ChildPath "logs"
    $LogPath = Join-Path -Path $OILogs -ChildPath "$LogName.log"
    $script:br = "--------------------------------------------------------------------------------------------------------"

    $LogArr = @(
                ($OIFld, 0),
                ($OILogs, 0), 
                ($LogPath, 1)
                )

    ForEach ($item in $LogArr) {
        if ($item[1] -eq 0) {
            New-Item -ItemType Directory -Path $item[0] -Force
        } else {
            New-Item -ItemType file -Path $item[0] -Force 
        }
    }
    return
}