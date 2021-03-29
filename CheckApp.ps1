Function CheckApp {
    Param(
        [Parameter(Position=0)]
        [string]$AppReg
    )

    $Reg64 = Test-Path -LiteralPath "HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$AppReg"
    $Reg32 = Test-Path -LiteralPath "HKLM:SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\$AppReg"
    
    if($Reg64 -Or $Reg32) {
        return $True
    } else {
        return $False
    }
}