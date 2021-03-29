Function CrShortcut {
    param (
        [Parameter(Position=0)]
        [string]$Path,
        [Parameter(Position=1)]
        [string]$Name,  #Name without extension
        [Parameter(Position=2)]
        [string]$Target,
        [Parameter(Position=3)]
        [string]$Icon = $Target
    )

    $FullPath = Join-Path -Path $Path -ChildPath "$Name.lnk"

    if (!(Test-Path -Path $FullPath)) {
        CrFld $Path
        Write-Log -Type 4 -msg "Creating new shortcut: $($Name) in directory: $($Path)"
        $WShell = New-Object -ComObject WScript.Shell -Strict -ErrorAction Stop
        $SC = $WShell.CreateShortcut($FullPath)
        $SC.TargetPath = $Target
        $SC.IconLocation = $Icon
        $SC.Save()
    } else {
        Write-Log -Type 1 -msg "Shortcut: $($Name) already exists in: $($Path)"
    }
}