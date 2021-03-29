Function CrReg {
    param(
        [Parameter(Position=1)]
        [string]$Reg,
        [Parameter(Position=2)]
        [array]$Prop = $null
    )

    if (!(Test-Path -Path $Reg)) {
        Write-Log -type 4 -msg "Creating registry: $($Reg)"
        New-Item -Path $Reg
    }
    if ($Prop -ne $null) {
        ForEach ($item in $Prop) {
            Write-Log -type 4 -msg "Creating regkey: $($item[0]) = $($item[1]) - for: $($Reg)"
            New-ItemProperty -Path $Reg -Name $item[0] -Value $item[1]
        }
    }
}