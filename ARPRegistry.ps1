<#
.SYNOPSIS
    Function: ARPRegistry

.DESCRIPTION
    EXTENDED NAME:
    Add registry to create a position in Add Remove Programs list (appwiz.cpl)

    DESCRIPTION:
    Add a new position to the Add Remove Programs list

.PARAMETER AppName
    <STRING> 
    Application Name (Key name: DisplayName)

.PARAMETER Version
    <STRING> 
    Application Version (Key name: DIsplayVersion)

.PARAMETER Vendor
    <STRING> 
    Application publisher/Vendor (Key name: Publisher)

.PARAMETER isVisible
    (OPTIONAL PARAMETER)
    <INT>
    Default value: 0
    Should the software be visible on the Add Remove Programs?

.PARAMETER IconPath
    (OPTIONAL PARAMETER)
    <STRING>
    Icon for the software (path to main exe or ico file)
    Use only if isVisible parameter is set to 1

.PARAMETER UnInfo
    (OPTIONAL PARAMETER)
    <STRING>
    Default value: "Please uninstall this software through the SOFTWARE CENTER!"
    Uninstall info. This function is not creating uninstall command in UninstallString to force the uninstall process through the Software Center!
    Will be used only if isVisible is set to 1

.EXAMPLE
    Create software registry + new position in Add Remove Programs with default uninstall info:
    ARPRegistry -AppName "Test Application" -Version "5.0" -Vendor "FineCompany" -isVisible 1 -IconPath "C:\Program Files\TestApp\5.0\Testapp.exe"
    ARPRegistry "Test Application" "5.0" "FineCompany" 1 "C:\Program Files\TestApp\5.0\Testapp.exe"

.EXAMPLE
    Create software registry not visible in Add Remove Programs
    ARPRegistry -AppName "Test Application" -Version "5.0" -Vendor "FineCompany"
    ARPRegistry "Test Application" "5.0" "FineCompany"

.NOTES
    PREREQUISITES:
    1) Logging function

    REVISION HISTORY:
        ver. 1.00 - 15/01/2020 - Initial version
#>

Function ARPRegistry {
    param (
        [Parameter(Position=0)]
        [string]$AppName,
        [Parameter(Position=1)]
        [string]$Version,
        [Parameter(Position=2)]
        [string]$Vendor,
        [Parameter(Position=3)]
        [int]$isVisible = 0,
        [Parameter(Position=4)]
        [string]$IconPath,
        [Parameter(Position=5)]
        [string]$UnInfo = "Please uninstall this software through the SOFTWARE CENTER!"
    )

    $FullName = "$($AppName) $($Version)"

    $ARPPath = "hklm:SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
    $ARPReg = "$ARPPath\$FullName"
    $PopUp = "mshta vbscript:Execute($($dbq)msgbox $($dbq)$($dbq)$($UnInfo)$($dbq)$($dbq):close$($dbq))"

    $MainKeys = @(
        ("DisplayName", $AppName),
        ("DisplayVersion", $Version),
        ("Publisher", $Vendor)
    )

    $AddKeys = @(
        ("UninstallString", $PopUp),
        ("DisplayIcon", $IconPath)
    )

    if (!(Test-Path -Path $ARPReg)) {
        Write-Log -type 4 -msg "Creating APPWIZ registry key for: $FullName"
        New-Item -Path $ARPReg
        ForEach ($item in $MainKeys) {
            if ($item[1].length -gt 0) {
                Write-Log -type 4 -msg "Creating key: $($item[0]) value: $($item[1])"
                New-ItemProperty -Path $ARPReg -Name $item[0] -Value $item[1]
            }
        }
    }

    if ($isVisible -eq 1) {
        Foreach ($item in $AddKeys) {
            if ($item[1].length -gt 0) {
                Write-Log -type 4 -msg "Creating key: $($item[0]) value: $($item[1])"
                New-ItemProperty -Path $ARPReg -Name $item[0] -Value $item[1]
            }
        }
    }
}