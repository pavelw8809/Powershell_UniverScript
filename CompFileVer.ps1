Function CompFileVer {
    param (
        [Parameter(Position=0)]
        [string]$FileToComp,
        [Parameter(Position=1)]
        [string]$Version
    )

    if (Test-Path -Path $FileToComp) {
        $CheckFileVer = (Get-Item $FileToComp).VersionInfo.FileVersion
        $FileVersion = ($CheckFileVer).replace(" ","")
        if ($FileVersion -eq $Version) {
            return $True
        } else {
            return $False
        }
    } else {
         Write-Log -Type 1 -msg "File: $($FileToComp) does not exist. Nothing to compare."
         return $False
    }
}