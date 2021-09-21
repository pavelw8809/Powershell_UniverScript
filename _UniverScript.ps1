<#
.SYNOPSIS
    Universal Script for Powershell

.DESCRIPTION
    This script contains a bunch of usefull functions for common tasks

    Function List:
        NO. NAME                PARAMETERS                            DESCRIPTION
        -------------------------------------------------------------------------------------------------------------------------------------------------
        01. AddObj            / OBJ                                 / Creates folder or file depending on the argument
        02. AppInstall        / ARE,  APP,  ARG,  ANM,  TOT^        / Main installation function
        03. AppUninstall      / ARE,  APP,  ARG,  ANM,  TOT^        / Main uninstallation function
        04. ARPRegistry       / ANM,  VER,  VND,  ISV^, ICO^,  UIN^ / Creates new key in HKLM:/SOFTWARE/Microsoft/Windows/CurrentVersion/Uninstall and new position in Add Remove Programs
        05. CheckApp          / ARE                                 / Checks if application is installed by uninstall registry
        06. CheckObjType      / OBJ                                 / Checks if object is a folder or a file
        07. CheckProc         / PNM                                 / Checks if process is running. Returns values true and false
        08. CheckProcAndKill  / PNM,  INL^, TOT^                    / Checks process for a specified time period and killing it (if appears) - Args: ProcessName, Interval, Timeout
        09. CheckSrvAndStop   / SRV,  DNM^, INL^, TOT^              / Waiting for a specified process in a specified time period. Once it's found it's stoped. Args: ServiceName, DisplayName, Interval, Timeout
        10. CompFiles         / OBJ,  OBJ                           / Compares two files and returns true if they are identical or false if they are different
        11. CopyObj           / OBC,  DST,  OVW^                    / Copies object (file, folder) - check if exist or overwrite
        12. CrFile            / OBJ                                 / Creates a file (path is also created if not exists)
        13. CrFileWithContent / OBJ,  CNT                           / Creates a file and writes a content in it. If the file exists it's adding new lines - Args: full path of the file to create, array with lines to write
        14. CrFld             / OBJ                                 / Creates a folder
        15. CrLog           /                                     / Creates installation according to $script:LogPath variable specified in the beginning of the script
        16. CrShortcut        / PTH,  SCM,  TRG,  ICO^              / Creates new shortcut in specified location. If path does not exists it's created automatically.
        17. CompFileVer       / OBJ,  VER                           / Compares file versions - selected file to version specified in the second parameter.
        18. CrReg             / REG,  RNV^                          / Creates registry key and keyname, keyvalue (if specified). The second optional argument RNV must be a 2-DIMENSIONAL ARRAY.
        19. EndLog            / -                                   / Creates a summary for the whole log
        20. FindCCMContent    / STR,  GTF^                          / Find folder in ccmcache with specified content. Args: Filename or a piece of filename + GetFist option if we want only one first found folder. GetFirst is off by default. To turn it on give $true value for the 2nd arg.
        21. FindSoftwareByName/ STR                                 / Find installed software on machine by name - Arg: string (software name or part of name). Returns the following properties: IdentifyingNumber (GUID), Name, Version
        22. GetSoftwareInfo   / ARE                                 / Get complete software info from HKLM registry like DisplayName, DisplayVersion and others
        23. GetSSIDList       / -                                   / Get SSID list from HKU reg. hive for each users
        24. InstallCMD        / APP,  ARG,  ANM,  RCL^, TOT^        / Installation Core Function - called by AppInstall/AppUninstall functions (without checking if software exists) 
        25. IsInt             / VAL                                 / Checks if value is an integer
        26. IsProcActive      / PNM,  INT^                          / Checking the process multiple times every 5 seconds (default: 3 times, waiting time: Q*5) - Args: Process Name, numbers of attempts as INT
        27. KillProcess       / PNM                                 / Killing process (process without extension)
        28. KillService       / SRV                                 / Removes services
        29. MinuteFormat      / INT                                 / Format value to time (hours, minutes and seconds)
        30. MSIAutoInstall    / -                                   / Automatically installs all the msi files located in current location. 
        31. MSIGetProp        / MSI,  PRO,  TBL^                    / MSI file - Get values from Property table or any other MSI table (default: Property table)
        32. MSIInstall        / MSI,  MST^, ADP^                    / MSI Installation function - Running MSI with MST and with additional props if needed. Default properties: REBOOT=ReallySuppress, ALLUSERS=1
        33. MSIUninstall      / MIN,  MST^, ADP^                    / MSI Uninstallation function - Uninstalls MSI. Input: GUID or MSI Full Path. MST file and additional props can be specified. Default properties: REBOOT=ReallySuppress, ALLUSERS=1
        34. ReadCSV           / CSV                                 / Read all the content from CSV file, so it can be used in the script
        35. RemObj            / OBJ                                 / Removes files and folders
        36. RemUserObj        / OBJ                                 / Removes files and folders for each user - Argument: Path after %SYSTEMDRIVE%\Users\{username}\
        37. ReplFileContent   / SRC,  DST                           / Read content in source files and copies it to another files (replacing it). It also automatically creates new destination file if it does not exist.
        38. SetEnvVar         / VAR,  VVL,  VTP^                    / Set environment variable for users and system. VTP: 0 - users and system, 1 - system only, 2 - users only (default option: 0)
        39. SetMachineVar     / VAR,  VVL                           / Set machine environment variable.
        40. SetUserReg        / REP,  RKN,  RVL                     / Changes registry value for each user SSID in HKU 
        41. SetUserVar        / VAR,  VVL                           / Set environment variable for all users.
        42. StartLog          / -                                   / Creates first lines of the log - Initial information
        43. StartService      / SRV,  DNM^                          / Starts specified service if it exists. Args: ServiceName, DisplayName
        44. StopService       / SRV,  DNM^                          / Stops specified service if it exists. Args: ServiceName, DisplayName
        45. StatusDescription / ANM,  ERR                           / Function for interpreting and describing error codes from install operation
        46. ValidateParam     / SNM,  ARR,  SNS                     / Function for validation given script arguments - SNM: Switch/Var name, ARR: value array, SNS: Switch/Var name as string.
        47. WaitForProcess    / PNM,  TOT^                          / Waiting for process finishing - default waiting time 3600s
        48. Write-Log         / MSG,  LTP                           / Creates log file
        -------------------------------------------------------------------------------------------------------------------------------------------------

        PARAMETERS LEGEND:

        ^   - Optional parameter         | DNM - Display Name               | LTP - Log Type                   | PRO - MSI Property               | SNM - Switch Name as variable    | VAL - Value                      | 
        ADP - Add MSI property           | DST - Destination (full path)    | MIN - MSI Full Path or GUID      | PTH - Path                       | SNS - Switch Name in string      | VAR - Variable Name              | 
        ANM - Application Name           | ERR - Error Code                 | MSG - Log Text                   | RCL - Ret Code List              | SRC - Source Full (full path)    | VER - Version                    | 
        APP - Application Path           | GTF - Return First item only     | MSI - Full path to MSI           | REG - Registry (full path)       | SRV - Service Name               | VND - Vendor Name                | 
        ARE - Application Reg            | ICO - Icon Path                  | MST - Full path to MST           | REP - Registry path after SSID   | STR - String                     | VTP - Variable Type              | 
        ARG - Install Args               | INL - Interval (int sec.)        | OBC - Object To Copy             | RKN - Registry Key Name          | TBL - MSI Table                  | VVL - Variable Value             | 
        ARR - Value Array                | INT - Integer Value              | OBJ - Object (full path)         | RVL - Registry value as string   | TOT - Operation TimeOut          | 
        CNT - Content (array)            | LFD - Log Folder                 | OVW - Overwrite option           | RNV - Reg. keyname/keyval.       | TRG - Target Path                | 
        CSV - Path to csv file           | LNM - Log Name                   | PNM - Process Name               | SCN - Shortcut Name (no ext)     | UIN - Uninistall Info            | 

.NOTES
    FileName:   UniversalScript.ps1
    Version     2.04
    Date:       24/02/2021
    Author:     Pawel Wieczorek
    
    Revision History:
        ver. 1.00 - 15/01/2020 - Initial Version
        ver. 1.01 - 06/03/2020 - NEW FUNCTIONS: CopyObj, MinuteFormat, WaitForProcess; 
                                 UPDATES: Write-Log (arg from -Type to -type)
                                 INFO: script info added
        ver. 1.02 - 11/03/2020 - NEW FUNCTIONS: CrReg
                                 UPDATES: CopyObj (adding overwriting and not-overwriting options)
        ver. 1.03 - 24/03/2020 - NEW FUNCTIONS: CheckProc, CheckProcAndKill, CompFileVer, CrShortcut
        ver. 1.04 - 07/04/2020 - NEW FUNCTIONS: CrFileWithContent
        ver. 1.05 - 30/04/2020 - NEW FUNCTIONS: RemUserObj
        ver. 1.06 - 03/11/2020 - Tools for MSI handling added. NEW FUNCTIONS: MSIInstall, MSIUninstall, MSIAutoInstall, MSIGetProp
        ver. 1.07 - 04/11/2020 - UPDATES: MSIUninstall (handling filepath and GUID), StatusDescription (Error 802 added - GUID not found)
        ver. 1.08 - 18/11/2020 - NEW FUNCTIONS: IsProcActive, SetUserReg
        ver. 1.09 - 11/12/2020 - NEW FUNCTIONS: CompFiles, ReadCSV, ReplFileContent
        ver. 1.10 - 15/12/2020 - NEW FUNCTIONS: GetSSIDList, SetEnvVar, SetMachineVar, SetUserVar
                                 UPDATES: SetUserReg (uses GetSSIDList + creating new regkey if it does not exist)
                                 INFO: ValidateParam description enhancement
        ver. 1.11 - 13/01/2021 - NEW FUNCTIONS: FindSoftwareByName
        ver. 2.00 - 20/01/2021 - NEW FUNCTIONS: CheckSrvAndStop, StartService, StopService
                                 UPDATES: Write-Log (*type* argument for Write-Log function was changes from numeric to more acessible form: default, warning, error, success, info, cyan, yellow)
                                 INFO: Changing logging in all functions
        ver. 2.01 - 26/01/2021 - UPDATES: CrOILog (arguments removed, LogPath specified in LogPath script variable in the beginning of the script)
                                 UPDATES: Write-Log (automatically creates Log File if it does not exist). Parameters: LogFolder and LogPath removed. LogPath must be specified in $script:LogPath
        ver. 2.02 - 27/01/2021 - NEW FUNCTIONS: GetSoftwareInfo
        ver. 2.03 - 04/02/2021 - NEW FUNCTIONS: FindCCMContent
        ver. 2.04 - 24/02/2021 - UPDATES: StopService (service checking modified to bool.)

    To be released soon:
        01. RemUserReg - remove registry for each user
        02. RemUserVar
        03. RemMachineVar
        04. ExportCSV
        05. ZIP
        06. UnZIP
        07. CheckADSite
        08. FindFileByName
#>

# UNIVERSCRIPT MAIN INFO

$USVer = "2.04"

# FUNCTIONS

$dbq=$([char]34)
#$WorkDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$MSIPath=join-path -path $env:WinDir -childpath 'System32\msiexec.exe'
$LogFld = Join-Path -Path $Env:SystemDrive -ChildPath "Logs"

Function AddObj {
    param(
        [Parameter(Position=1)]
        [string]$Obj
    )

    $objType = CheckObjType($Obj)

    switch($objType) {
        0 {
            CrFile $Obj
        }
        1 {
            CrFld $Obj
        }
    }
}

Function AppInstall {
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
    
    if(!($Reg64 -Or $Reg32)) {
        Write-Log -type "info" -msg "Start $AppName installation"
        InstallCMD -Proc $App -Args $AppArgs -AppName $AppName -Time $Time
        if(!($isSuccess)) {
            EndLog
            Set-Strictmode -Off
            exit $ErrVal
        }
    } else {
        StatusDescription $AppName 800
        return $script:isSuccess = $True
    }
}

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
        #Write-Log -type "warning" -msg "$AppName is already uninstalled on the machine."
        StatusDescription $AppName 801 
        return $script:isSuccess = $True
    }
}

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
        Write-Log -type "info" -msg "Creating APPWIZ registry key for: $FullName"
        New-Item -Path $ARPReg
        ForEach ($item in $MainKeys) {
            if ($item[1].length -gt 0) {
                Write-Log -type "info" -msg "Creating key: $($item[0]) value: $($item[1])"
                New-ItemProperty -Path $ARPReg -Name $item[0] -Value $item[1]
            }
        }
    }

    if ($isVisible -eq 1) {
        Foreach ($item in $AddKeys) {
            if ($item[1].length -gt 0) {
                Write-Log -type "info" -msg "Creating key: $($item[0]) value: $($item[1])"
                New-ItemProperty -Path $ARPReg -Name $item[0] -Value $item[1]
            }
        }
    }
}

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

Function CheckObjType {
    param(
        [Parameter(Position=0)]
        [string]$Obj
    )

    Write-Log -type "info" -msg "Checking object: $($Obj)"

    # Check if obj is a file

    $objL = $Obj.Length  # Length of object
    $objF = $objL - 6    # Beginning of area where the script is finding an extension
    $i = $objL - 1		 # End of the area where the script is finding an extension
    $ExtArr = @()

    While($i -ge $objF) {
        if ($Obj[$i] -eq ".") {
            return 0
        }
        $i = $i - 1
    }

    return 1
}

Function CheckProc {
    param (
        [Parameter(Position=0)]
        [string]$ProcName
    )

    $CheckProc = Get-Process -Name $ProcName -ErrorAction SilentlyContinue
    if ($CheckProc) {
        return $True
    } else {
        return $False
    }
}

Function CheckProcAndKill {
    param (
        [Parameter(Position=0)]
        [string]$ProcName,
        [Parameter(Position=1)]
        [int]$Interval = 5,
        [Parameter(Position=2)]
        [int]$Timeout = 600
    )

    $t = 0

	do {
        $ElapsedTime = MinuteFormat $t
        $FinishTime = MinuteFormat $Timeout
        $CheckProc = Get-Process -Name $ProcName -ErrorAction SilentlyContinue
        Write-Host $CheckProc
        if ($CheckProc) {
            KillProcess $ProcName
            $e = 1
        } else {
            $e = 0
        }
		Write-Log -type "info" -msg "Waiting for process to kill $($ProcName) - time: $($ElapsedTime)/$($FinishTime)"
		$t = $t+$Interval
		Start-Sleep -s $Interval
	} while (($t -le $Timeout) -and ($e -eq 0))
}

Function CheckSrvAndStop {
    param (
        [Parameter(Position=0)]
        [string]$Name = "",
        [Parameter(Position=1)]
        [string]$DisplayName = "",
        [Parameter(Position=2)]
        [int]$Interval = 5,
        [Parameter(Position=3)]
        [int]$Timeout = 600
    )

    if (!$Name -And !$DisplayName) {
        Write-Log -type "warning" -msg "Neither Name nor DisplayName property were specified"
    } elseif ($Name) {
        $SrvName = $Name
        $CheckSrv = Get-Service -Name $SrvName -ErrorAction SilentlyContinue
    } else {
        $SrvName = $DisplayName
        $CheckSrv = Get-Service -DisplayName $SrvName -ErrorAction SilentlyContinue
    }

    $t = 0

	do {
        $ElapsedTime = MinuteFormat $t
        $FinishTime = MinuteFormat $Timeout
        $CheckSrv = Get-Service -Name $SrvName -ErrorAction SilentlyContinue
        $SrvStatus = $CheckSrv.Status

        if ($CheckSrv.length -gt 0 -And ($SrvStatus -eq "Running" -Or $SrvStatus -eq "Automatic")) {
            Write-Log -type "info" -msg "Service $($SrvName) was found - stopping..."
            try {
                Stop-Service -Name $SrvName -ErrorAction Stop
            }
            catch {
                Write-Log -type "error" -msg "Service $($SrvName) could not be stopped."
                return
            }
            $e = 1
        } else {
            $e = 0
        }
		Write-Log -type "cyan" -msg "Waiting for service $($SrvName) to stop $($ProcName) - time: $($ElapsedTime)/$($FinishTime)"
		$t = $t+$Interval
		Start-Sleep -s $Interval
	} while (($t -le $Timeout) -and ($e -eq 0))
}

Function CompFiles {
    param(
        [Parameter(Position=0)]
        [string]$File1,
        [Parameter(Position=1)]
        [string]$File2
    )

    $CompFiles = @($File1, $File2)
    $PathComplied = 0

    ForEach ($item in $CompFiles) {
        If (Test-Path -Path $item) {
            $PathComplied = $PathComplied+1
        } else {
            Write-Log -type "warning" -msg "File was not found: $($item)"
        }
    }

    If ($PathComplied -eq 2) {
        try {
            $Hash1 = (Get-FileHash -Path $File1 -Algorithm MD5 -ErrorAction Stop).Hash
            $Hash2 = (Get-FileHash -Path $File2 -Algorithm MD5 -ErrorAction Stop).Hash

            if ($Hash1 -eq $Hash2) {
                Write-Log "Hash 1: $($Hash1) / Hash2: $($Hash2) - Files are identical"
                return $true
            } else {
                Write-Log "Hash 1: $($Hash1) / Hash2: $($Hash2) - Files are different"
                return $false
            }
        }
        catch {
            Write-Log -type "error" -msg "File hash for $($File1) could not be generated - check the path."
        }
    } else {
        Write-Log -type "warning" -msg "One of the file was not found. Nothing to do."
    }
}

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
         Write-Log -type "warning" -msg "File: $($FileToComp) does not exist. Nothing to compare."
         return $False
    }
}

Function CopyObj {
    param (
        [Parameter(Position=0)]
        [string]$ObjToCopy,
        [Parameter(Position=1)]
        [string]$Dest,
        [Parameter(Position=2)]
        [string]$Overwrite = $null #Overwrite option. To turn on give 'ov' argument 
    )

    if (Test-Path $ObjToCopy) {
        if (!(Test-Path $Dest)) {
            Write-Log -type "info" -msg "Creating destination path: $($Dest)"
            CrFld $Dest
        }

        if ($Overwrite -eq "ov") {
            if (Test-Path $ObjToCopy) {
                if (!(Test-Path $Dest)) {
                    Write-Log -type "info" -msg "Creating destination path: $($Dest)"
                    CrFld $Dest
                }
                try {
                    Write-Log -type "info" -msg "Copying files - FROM: $($ObjToCopy) TO: $($Dest)"
                    Copy-Item $ObjToCopy $Dest -Force
                } 
                catch {
                    Write-Log -type "error" -msg "Copying to path: $($Dest) failed"
                }
            } else {
                Write-Log -type "warning" -msg "Nothing to copy"
            }
        } else {
            $srcfld = Split-Path $objToCopy -Parent
            $getsrc = Get-ChildItem $srcfld
            $srccount = ($getsrc | Measure-Object).count

            if (($srccount -gt 1) -and ($ObjToCopy.endswith("*"))) {
                ForEach ($item in $getsrc) {
                    $fcheck = Join-Path -Path $Dest -ChildPath $item
                    $ftocopy = Join-Path -Path $srcfld -ChildPath $item
                    $fname = Split-Path -Path $ftocopy -Leaf
                    if (!(Test-Path -Path $fcheck)) {
                        try {
                            Write-Log -type "info" -msg "Copying object: $($item) TO: $($Dest)"
                            Copy-Item $ftocopy $Dest -Recurse -Force
                        } 
                        catch {
                            Write-Log -type "error" -msg "Copying to path: $($Dest) failed"
                        }
                    } else {
                        Write-Log -type "warning" -msg "Object: $($fname) already exists in $($Dest)"
                    }
                }
            } else {
                $fname = Split-Path $objToCopy -Leaf
                $fcheck = Join-Path -Path $Dest -ChildPath $fname
                if (!(Test-Path $fcheck)) {
                    try {
                        Write-Log -type "info" -msg "Copying object: $($objToCopy) TO: $($Dest)"
                        Copy-Item $objToCopy $Dest -Recurse -Force
                    } 
                    catch {
                        Write-Log -type "error" -msg "Copying to path: $($Dest) failed"
                    }
                } else {
                    Write-Log -type "warning" -msg "Object: $($fname) already exists in $($Dest)"
                }
            }
        }
    } else {
        Write-Log -type "warning" -msg "Object to copy: $($ObjToCopy) was not found. Nothing to copy"
    }
}
Function _CopyObjOld {
    param (
        [Parameter(Position=0)]
        [string]$ObjToCopy,
        [Parameter(Position=1)]
        [string]$Dest
    )

    if (Test-Path $ObjToCopy) {
        if (!(Test-Path $Dest)) {
            Write-Log -type "info" -msg "Creating destination path: $($Dest)"
            CrFld $Dest
        }
        try {
            Write-Log -type "info" -msg "Copying files- FROM: $($ObjToCopy) TO: $($Dest)"
            Copy-Item $ObjToCopy $Dest -Force
        } 
        catch {
            Write-Log -type "error" -msg "Copying to path: $($Dest) failed"
        }
    } else {
        Write-Log -type "warning" -msg "Nothing to copy"
    }
}

Function CrFile {
    param(
        [Parameter(Position=0)]
        [string]$File
    )

    $FilePath = Split-Path $File
    $FileName = Split-Path $File -Leaf

    CrFld $FilePath

    if (!(Test-Path $File)) {
        try {
            Write-Log -type "info" -msg "Creating file: $($File)"
            New-Item -Path $File -ItemType "file" -Force 
        }
        catch {
            Write-Log -type "error" -msg "ERROR - The file: $($FileName) could not be created in: $($FilePath)."
        }
    }
}

Function CrFileWithContent {
    param(
        [Parameter(Position=0)]
        [string]$File,
        [Parameter(position=1)]
        [string[]]$Content #Array of lines
    )

    CrFile $File
    ForEach ($item in $Content) {
        Write-Log -type "info" -msg "Writing line: $($item) to $($file)"
        Add-Content -Value $item -Path $File
    }
}

Function CrFld {
    param(
        [Parameter(Position=0)]
        [string]$Fld
    )

    if (!(Test-Path $Fld)) {
        try {
            Write-Log -type "info" -msg "Creating folder: $($Fld)"
            New-Item -ItemType Directory -Path $Fld -Force
        }
        catch {
            Write-Log -type "error" -msg "ERROR - The folder: $($Fld) could not be created."
        }
    }
}

Function CrLog {

    $script:br = "--------------------------------------------------------------------------------------------------------"
    $LogFld = Split-Path $LogPath

    if (!(Test-Path -Path $LogFld)) {
        New-Item -ItemType directory -Path $LogFld
    }

    if (!(Test-Path -Path $LogPath)) {
        New-Item -ItemType file -Path $LogPath
    }
}

Function CrReg {
    param(
        [Parameter(Position=1)]
        [string]$Reg,
        [Parameter(Position=2)]
        [array]$Prop = $null
    )

    if (!(Test-Path -Path $Reg)) {
        Write-Log -type "info" -msg "Creating registry: $($Reg)"
        New-Item -Path $Reg
    }
    if ($Prop -ne $null) {
        ForEach ($item in $Prop) {
            Write-Log -type "info" -msg "Creating regkey: $($item[0]) = $($item[1]) - for: $($Reg)"
            New-ItemProperty -Path $Reg -Name $item[0] -Value $item[1]
        }
    }
}

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
        Write-Log -type "info" -msg "Creating new shortcut: $($Name) in directory: $($Path)"
        $WShell = New-Object -ComObject WScript.Shell -Strict -ErrorAction Stop
        $SC = $WShell.CreateShortcut($FullPath)
        $SC.TargetPath = $Target
        $SC.IconLocation = $Icon
        $SC.Save()
    } else {
        Write-Log -type "warning" -msg "Shortcut: $($Name) already exists in: $($Path)"
    }
}

Function EndLog {

    if ($ErrCode -eq 0) {
        $isSuccess = $True
        $StatusDesc = "Script was completed successfully"
    }

    if ($isSuccess -eq $True) {
        $Status = "SUCCESS"
    } else {
        $Status = "ERROR"
    }

    Write-Log -type "cyan" -msg " "
    Write-Log -type "cyan" -msg "F I N A L   R E S U L T :"
    Write-Log -type "cyan" -msg "$($br)"
    Write-Log -type "cyan" -msg "SCRIPT COMPLETED WITH $Status"
    Write-Log -type "cyan" -msg "ERROR CODE: $ErrCode"
    Write-Log -type "cyan" -msg "DESCRIPTION: $StatusDesc"
    Write-Log -type "cyan" -msg "$($br)"
    Write-Log -type "cyan" -msg " "
}

Function FindCCMContent {
    param(
        [Parameter(Position=0)]
        [string]$FileName,
        [Parameter(Position=1)]
        [string]$GetFirst = $false
    )

    $CCMFld = Join-Path -Path $Env:SystemRoot -ChildPath "ccmcache"
    $SearchCCM = Get-ChildItem -Path $CCMFld -Recurse | Where {$_.name -like "*$FileName*"} | Select -ExpandProperty FullName | Split-Path -Parent
    $ResultLength = ($SearchCCM | Measure-Object).count

    Write-Log "Searching content in ccmcache by file name like: $FileName"

    if ($ResultLength -gt 0) {
        if ($GetFirst -eq $true) {
            Write-Log "GetFirst option was turned on. Only first item will be returned."
            $SrcPath = $SearchCCM | Select -First 1
            Write-Log "CCM sources was found in: $($SrcPath)"
            return $SearchCCM | Select -First 1
        }
        Write-Log "$($ResultLength) folders was found for name: $($FileName)"
        $SrcList = $SearchCCM | Select -Unique
        ForEach ($item in $SrcList) {
            Write-Log "CCM sources was found in: $($item)"
        }
        return $SrcList
    } else {
        Write-Log -type "warn" -msg "No sources was found for name: $($FileName)"
    }
}

Function FindSoftwareByName {
    param(
        [Parameter(Position=0)]
        [string]$Name
    )

    Write-Log "Searching for the software that includes the string: $($Name)"

    $SoftQuery = Get-WmiObject -Class win32_product | Where-Object {
                        ($_.Name -like "*$Name*")
                    }

    $QueryCount = ($SoftQuery | Measure-Object).count

    if ($QueryCount -eq 0) {
        Write-Log -type "warning" -msg "Software name with the string $($Name) was not found"
    } else {
        Write-Log "Software was found. Quantity: $($QueryCount)"
    }

    return $SoftQuery
}

Function GetSoftwareInfo {
    param(
        [Parameter(Position=0)]
        [string]$GUID
    )

    $SoftReg64 = "HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$($GUID)"
    $SoftReg32 = "HKLM:SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\$($GUID)"

    if (Test-Path $SoftReg64) {
        $SoftReg = Get-ItemProperty -Path $SoftReg64
    } elseif (Test-Path $SoftReg32) {
        $SoftReg = Get-ItemProperty -Path $SoftReg32
    } else {
        return $null
    }

    return $SoftReg
}

Function GetSSIDList {
    $GetPSDrive = Get-PSDrive -Name HKU -ErrorAction SilentlyContinue

    if (($GetPSDrive | Measure-Object).Count -eq 0) {
        New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS
    }

    $SSIDList = Get-ChildItem -Name "HKU:"

    return $SSIDList
}

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

Function IsInt {
    param (
        [Parameter(Position=0)]
        [string]$Value
    )

    $intCheck = $ProcVal -match "^[\d\.]+$"

    if ($intCheck -eq $True) {
        return $True
    } else {
        return $False
    }
}

Function IsProcActive {
    param(
        [Parameter(Position=0)]
        [string]$ProcName,  # Process Name to check (without extension)
        [Parameter(Position=1)]
        [int]$Q = 3         # Amount of attempts (1 attempt every 5 seconds, time: Q*5)
    )

    $i = 0

    while ($i -le $Q) {
        $CheckProc = Get-Process -Name $ProcName -ErrorAction SilentlyContinue
        if (!$CheckProc) {
            Write-Log -type "info" -msg "Process: $($ProcName) not found - attempt $($i)/$($Q)"
            $i = $i+1
            Start-Sleep -s 5
        } else {
            $i = 0
        }

        if ($i -gt $Q) {
            Write-Log -type "success" -msg "Process: $($ProcName) does not exist anymore - continuing..."
        }
    }
}

Function KillProcess {
    Param($ProcName)

    $Proc = Get-Process $ProcName -ErrorAction SilentlyContinue

    if ($Proc) {
        Write-Log -type "info" -msg "Process: $ProcName was found - killing..."
        $Proc | Stop-Process -Force
    }
}

Function KillService {
    param($ServiceName)

    $sctool = join-path -path $env:SystemRoot -childpath "System32\sc.exe"

    Write-Log -type "info" -msg "Deleting service: $ServiceName"
    Start-Process -FilePath $sctool -ArgumentList "delete $ServiceName"
}

Function MinuteFormat {
    param(
        [Parameter(Position=0)]
        [int]$seconds
    )

    $min = 0
    $sec = $seconds

    if ($seconds -ge 60) {
        $min = [math]::Floor($seconds/60)
        $sec = $seconds-($min*60)
    }

    if ($min -lt 10) {
        $min = "0$min"
    }
    if ($sec -lt 10) {
        $sec = "0$sec"
    }

    if ($min -ge 60) {
        $h = [math]::Floor($min/60)
        $min = $min-($h*60)
        if ($h -lt 10) {
            $h = "0$h"
        }
        return "$($h)h:$($min)m:$($sec)s"
    }

    return "$($min)m:$($sec)s"
}

Function MSIAutoInstall {
    $FindMSI = Get-ChildItem -Path $WorkDir -Filter *.msi

    if (@($FindMSI).Count -gt 0 ) {
        Foreach ($item in $FindMSI) {

            Write-Log -type "info" -msg "The MSI file was found: $($item)"

            $PathToMSI = Join-Path -Path $WorkDir -ChildPath $item 

            #$Vendor = MSIGetProp $PathToMSI "Manufacturer"
            $ProductCode = MSIGetProp $PathToMSI "ProductCode" | Out-String
            $SoftwareName = MSIGetProp $PathToMSI "ProductName"
            $SoftwareVersion = MSIGetProp $PathToMSI "ProductVersion"
            #$UpgradeCode = MSIGetProp $PathToMSI "UpgradeCode"

            $GUID = ($ProductCode).substring(0, $ProductCode.Length-1)
            $AppNameData = "$($SoftwareName)$($SoftwareVersion)"
            $AppName = ($AppNameData).Substring(1,$AppNameData.Length-1)

            MSIInstall $PathToMSI
        }
    } else {
        Write-Log -type "warning" -msg "MSI was not found in current location"
    }
}

Function MSIGetProp {
    param (
        [Parameter(Mandatory=$True, Position=0)]
        [ValidateScript({$_.EndsWith(".msi")})]
        [string]$FilePath,
        [Parameter(Position=1)]
        [string]$Prop = "ProductCode",
        [Parameter(Position=2)]
        [string]$Table = "Property"
    )

    Try {
        $WinInstaller = New-Object -ComObject WindowsInstaller.Installer
        $MSIDB = $WinInstaller.GetType().InvokeMember("OpenDatabase","InvokeMethod",$null,$WinInstaller,@($FilePath, 0))

        $Query = "SELECT Value FROM $($Table) WHERE Property = '$($Prop)'"
        $View = $MSIDB.GetType().InvokeMember("OpenView","InvokeMethod",$null,$MSIDB,($Query))
        $View.GetType().InvokeMember("Execute", "InvokeMethod", $null, $View, $null)

        $Record = $View.GetType().InvokeMember("Fetch","InvokeMethod",$null,$View,$null)
        $Result = $Record.GetType().InvokeMember("StringData","GetProperty",$null, $Record, 1)

        #Write-Log $Result

        return (($Result).ToString()).replace("`n","")
    } Catch {
        Write-Host $_.Exception.Message
    }
}

Function MSIInstall {
    param (
        [Parameter(Mandatory=$True, Position=0)]
        [string]$InstallerPath,
        [Parameter(Position=1)]
        [string]$Transform = "",
        [Parameter(Position=2)]
        [string]$AddProp = ""
    )

    if ($AddProp.Length -gt 0) {
        $AddProp = " $AddProp"
    }

    if ($Transform.Length -gt 0) {
        $Transform = " TRANSFORMS=$dbq$dbq"
    }

    #$ProductCode = MSIGetProp $InstallerPath "ProductCode" | Out-String 
    $SoftwareName = MSIGetProp $InstallerPath "ProductName"
    $SoftwareVersion = MSIGetProp $InstallerPath "ProductVersion"

    $AppNameData = "$($SoftwareName)$($SoftwareVersion)"
    $AppName = ($AppNameData).Substring(1,$AppNameData.Length-1)

    $FullLogPath = Join-Path -Path $LogFld -ChildPath "$($AppName)_install.log"
    $AppArgs = "/i $dbq$InstallerPath$dbq REBOOT=ReallySuppress ALLUSERS=1$($AddProp) /qn /l*v $dbq$FullLogPath$dbq"

    Write-Log -type "info" -msg "Start $AppName installation"
    InstallCMD -Proc $MSIPath -Args $AppArgs -AppName $AppName
    if(!($isSuccess)) {
        EndLog
        Set-Strictmode -Off
        exit $ErrVal
    }
}

Function MSIUninstall {
    param (
        [Parameter(Mandatory=$True, Position=0)]
        [string]$InputData, # Path to MSI or GUID
        [Parameter(Position=1)]
        [string]$Transform = "",
        [Parameter(Position=2)]
        [string]$AddProp = ""
    )

    if ($AddProp.Length -gt 0) {
        $AddProp = " $AddProp"
    }

    if ($Transform.Length -gt 0) {
        $Transform = " TRANSFORMS=$dbq$Transform$dbq"
    }

    if ($InputData.StartsWith("{")) {
        $Reg64 = "HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$InputData"
        $Reg32 = "HKLM:SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\$InputData"
        $Reg = $null

        if (Test-Path -LiteralPath $Reg64) {
            $Reg = Get-ItemProperty -Path $Reg64
        } elseif (Test-Path -LiteralPath $Reg32) {
            $Reg = Get-ItemProperty -Path $Reg32
        }

        if($Reg -ne $null) {
            $AppName = "$($Reg.DisplayName) $($Reg.DisplayVersion)"
            Write-Log -type "info" -msg "Start $($AppName) uninstallation"
            $FullLogPath = Join-Path -Path $LogFld -ChildPath "$($AppName)_uninstall.log"
            $AppArgs = "/x $($InputData) REBOOT=ReallySuppress ALLUSERS=1$($AddProp) /qn /l*v $dbq$FullLogPath$dbq"
            InstallCMD -Proc $MSIPath -Args $AppArgs -AppName $AppName
            if(!($isSuccess)) {
                EndLog
                Set-Strictmode -Off
                exit $ErrVal
            }
        } else {
            StatusDescription $InputData 802 
            return $script:isSuccess = $True
        }
    } else {
        $SoftwareName = MSIGetProp $InputData "ProductName"
        $SoftwareVersion = MSIGetProp $InputData "ProductVersion"
    
        $AppNameData = "$($SoftwareName)$($SoftwareVersion)"
        $AppName = ($AppNameData).Substring(1,$AppNameData.Length-1)
    
        $FullLogPath = Join-Path -Path $LogFld -ChildPath "$($AppName)_uninstall.log"
        $AppArgs = "/x $dbq$InputData$dbq REBOOT=ReallySuppress ALLUSERS=1$($AddProp) /qn /l*v $dbq$FullLogPath$dbq"
    
        Write-Log -type "info" -msg "Start $AppName uninstallation"
        InstallCMD -Proc $MSIPath -Args $AppArgs -AppName $AppName
        if(!($isSuccess)) {
            EndLog
            Set-Strictmode -Off
            exit $ErrVal
        }
    }
}

Function ReadCSV {
    param(
        [Parameter(Position=0)]
        [string]$CSVFile
    )

    if (Test-Path -Path $CSVFile) {
        try {
            Import-CSV -Path $CSVFile
        }
        catch {
            Write-Log -type "warning" -msg "File: $($CSVFile) could not be read"
        }
    }
}

Function RemObj {
    param (
        [Parameter(Position=0)]
        [string]$Object
    )

    if (Test-Path -Path $Object) {
        Try {
            Write-Log -type "info" -msg "Deleting object: $Object"
            Remove-Item $Object -Recurse -Force
        } Catch {
            Write-Log -type "error" -msg "Object: $Object was not successfully removed"
        }
    }
}

Function RemUserObj {
    param (
        [Parameter(Position=0)]
        [string]$Object   # Path after %SYSTEMDRIVE%\Users\{username}\
    )

    $UserFld = Join-Path -Path $Env:SystemDrive -ChildPath "Users"
    $UserList = Get-ChildItem -Name $UserFld

    ForEach ($item in $UserList) {
        $ObjToRem = Join-Path -Path $UserFld -ChildPath "$item\$Object"
        RemObj $ObjToRem
    }
}

Function ReplFileContent {
    param(
        [Parameter(Position=0)]
        [string]$SrcFile,
        [Parameter(Position=1)]
        [string]$DestFile
    )

    If (Test-Path -Path $SrcFile) {
        if (!(Test-Path -Path $DestFile)) {
            CrFile $DestFile
        }
        
        Write-Log "Writing content to file: $($DestFile)"
        try{
            cmd /c copy /b $SrcFile $DestFile
            Write-Log -type "success" -msg "Content from $($SrcFile) was successfully read"
            Write-Log -type "success" -msg "Content was successfully written to $($DestFile)"
        }
        catch{
            Write-Log -type "error" -msg "Error - Content could not be saved in $($DestPath)"
        }
    } else {
        Write-Log -type "warning" -msg "Source file: $($SrcFile) was not found"
    }
}

Function SetEnvVar {
    param(
        [Parameter(Position=0)]
        [string]$VarName,
        [Parameter(Position=1)]
        [string]$VarVal,
        [Parameter(Position=2)]
        [int]$VarType=0    # 0 - set machine and user var., 1 - set machine var. only, 2 - set user var.
    )

    switch($VarType) {
        0 {
            SetMachineVar $VarName $VarVal
            SetUserVar $VarName $VarVal
        ; break}
        1 {
            SetMachineVar $VarName $VarVal
        ; break}
        2 {
            SetUserVar $VarName $VarVal
        ; break}
    }
}

Function SetMachineVar {
    param(
        [Parameter(Position=0)]
        [string]$VarName,
        [Parameter(Position=1)]
        [string]$VarVal
    )

    Write-Log "Setting machine env. variable: $($VarName) - value: $($VarVal)"

    try {
        [Environment]::SetEnvironmentVariable($VarName, $VarVal, 'machine')
    }
    catch {
        Write-Log -type "error" -msg "Env. variable could not be created"
    }

    $MVarPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
    $MVarCheck = (Get-ItemProperty $MVarPath -ErrorAction SilentlyContinue).$VarName -eq $VarVal

    if ($MVarCheck -eq $true) {
        Write-Log -type "success" -msg "Machine env. variable: $($VarName) was set successfully"
    } else {
        Write-Log -type "warning" -msg "Machine env. variable: $($VarName) was not set correctly"
    }
}

Function SetUserReg {
    param(
        [Parameter(Position=0)]
        [string]$RegPath,   # Registry path after SSID
        [Parameter(Position=1)]
        [string]$RegKey,    # Registry key to change
        [Parameter(Position=2)]
        [string]$RegValue   # Registry value to set
    )

    $SSIDList = GetSSIDList

    ForEach ($item in $SSIDList) {
        $FullRegPath = Join-Path -Path "HKU:$item" -ChildPath "$RegPath"
        $CheckSSIDPath = Join-Path -Path "HKU:$item" -ChildPath "Software"

        if (Test-Path -Path $CheckSSIDPath) {
            if (!(Test-Path $FullRegPath)) {
                Write-Log "Creating reg key: $($FullRegPath)"
                New-Item -Path $FullRegPath
            }
        
            if (Test-Path $FullRegPath) {
                Write-Log "Creating reg name: $($RegKey) / reg value: $($RegValue) for: $($FullRegPath)"
                Set-ItemProperty -Path $FullRegPath -Name $RegKey -Value $RegValue
            }
        }
    }
}

Function SetUserVar {
    param(
        [Parameter(Position=0)]
        [string]$VarName,
        [Parameter(Position=1)]
        [string]$VarVal
    )

    Write-Log "Setting user env. variable for all users: $($VarName) - value: $($VarVal)"

    $GetPSDrive = Get-PSDrive -Name HKU -ErrorAction SilentlyContinue

    if (($GetPSDrive | Measure-Object).Count -eq 0) {
        New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS
    }

    $SSIDList = GetSSIDList

    ForEach ($item in $SSIDList) {
        $UVarPath = Join-Path -Path "HKU:$($item)" -ChildPath "Environment"

        if (Test-Path -Path $UVarPath) {
            Write-Log "Creating $($VarName) for SSID: $($item)"
            Set-ItemProperty -Path $UVarPath -Name $VarName -Value $VarVal
        }
    }
}

Function StartLog {
    Write-Log -type "yellow" -msg "M A I N   I N F O R M A T I O N"
    Write-Log -type "yellow" -msg "$($br)"
    Write-Log -type "yellow" -msg "Computer Name:       $Env:COMPUTERNAME"
    Write-Log -type "yellow" -msg "UniversalScript Ver: $($USVer)"
    Write-Log -type "yellow" -msg "Script Name:         $($ScriptName)"
    Write-Log -type "yellow" -msg "Source directory:    $($WorkDir)"
    Write-Log -type "yellow" -msg "$($br)"
    Write-Log -type "yellow" -msg " "
    Write-Log -type "default" -msg "Script starting..."
    Write-Log -type "yellow" -msg " "
    Write-Log -type "yellow" -msg "S C R I P T   L O G G I N G"
    Write-Log -type "yellow" -msg "$($br)"
}

Function StartService {
    param(
        [Parameter(Position=0)]
        [string]$Name = $null,
        [Parameter(Position=1)]
        [string]$DisplayName = $null
    )

    if (!$Name -And !$DisplayName) {
        Write-Log -type "warning" -msg "Neither Name nor DisplayName property were specified"
    } elseif ($Name) {
        $SrvName = $Name
        $CheckSrv = Get-Service -Name $SrvName -ErrorAction SilentlyContinue
    } else {
        $SrvName = $DisplayName
        $CheckSrv = Get-Service -DisplayName $SrvName -ErrorAction SilentlyContinue
    }

    if ($CheckSrv.length -gt 0) {
        if ($CheckSrv.Status -eq "Stopped") {
            Write-Log -type "info" -msg "Service: $($CheckSrv.Name) was found - starting..."
            try {
                Start-Service -Name $CheckSrv.Name -ErrorAction Stop
            }
            catch {
                Write-Log -type "error" -msg "Service: $($CheckSrv.Name) could not be run."
            }
        } else {
            Write-Log -type "info" -msg "Service $($CheckSrv.Name) is already running."
        }
    } else {
        Write-Host -type "warning" -msg "Service: $($CheckSrv.Name) was not found"
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

Function StopService {
    param(
        [Parameter(Position=0)]
        [string]$Name = $null,
        [Parameter(Position=1)]
        [string]$DisplayName = $null
    )

    if (!$Name -And !$DisplayName) {
        Write-Log -type "warning" -msg "Neither Name nor DisplayName property were specified"
    } elseif ($Name) {
        $SrvName = $Name
        $CheckSrv = Get-Service -Name $SrvName -ErrorAction SilentlyContinue
    } else {
        $SrvName = $DisplayName
        $CheckSrv = Get-Service -DisplayName $SrvName -ErrorAction SilentlyContinue
    }

    if ($CheckSrv) {
        if ($CheckSrv.Status -eq "Running") {
            Write-Log -type "info" -msg "Service: $($CheckSrv.Name) was found - stopping..."
            try {
                Stop-Service -Name $CheckSrv.Name -ErrorAction Stop
            }
            catch {
                Write-Log -type "error" -msg "Service: $($CheckSrv.Name) could not be stopped."
            }
        } else {
            Write-Log -type "info" -msg "Service $($CheckSrv.Name) is already stopped."
        }
    } else {
        Write-Log -type "warning" -msg "Service: $Name was not found"
    }
}

Function ValidateParam {
    param(
        [Parameter(Position=0)]
        [string]$Switch,    # switch/variable name
        [Parameter(Position=1)]
        [string[]]$ValArr,  # values array
        [Parameter(Position=2)]
        [string]$propName   # switch name in string
    )

    $pass = 0

    ForEach ($item in $ValArr) {
        if ($Switch -eq $item) {
            $pass++
        }
    }

    if ($Pass -eq 0) {
        Write-Log -type "error" -msg "Error: Wrong $($propName) argument was selected. Available options: $($ValArr)."
        $ErrCode = 8
		$isSuccess = $False
        $StatusDesc = "Error: Wrong $($propName) argument was selected. Available options: $($ValArr)."
        EndLog
        exit $ErrCode
    }
}

Function WaitForProcess {
    param(
        [Parameter(Position=0)]
        [string]$Proc,
        [Parameter(Position=1)]
        [string]$TimeOut=3600
    )

    $sec = 0

    do {
        $CheckProcess = Get-Process -Name $Proc -ErrorAction SilentlyContinue
        $time = MinuteFormat $sec
        Write-Log -type "cyan" -msg "Waiting for process: $($Proc) - time: $($time)"
        Start-Sleep -s 5
        $sec = $sec+5
    }
    while ($CheckProcess -and ($sec -lt $TimeOut))
}

Function Write-Log {
    Param(
        [Parameter(Position=0, Mandatory=$True)]
        [string]$msg,
        [Parameter(Position=1)]
        [ValidateSet("default", "warning", "error", "success", "info", "cyan", "yellow")]
        [string]$type = "default"
    )

    if (!(Test-Path -Path $LogPath)) {
        CrOILog
    }

    $Timestamp = Get-Date -Format "MM-dd-yyyy_HH.mm:ss"

    switch($type) {
        "default" {
            $msg = "$Timestamp - $Msg"
            Write-Host $msg
        }
        "warning" {
            $msg = "$Timestamp - [WARNING] - $msg"
            Write-Host $msg -ForegroundColor yellow
        }
        "error" {
            $msg = "$Timestamp - [ERROR] - $msg"
            Write-Host $msg -ForegroundColor red
        }
        "success" {
            $msg = "$Timestamp - [SUCCESS] - $msg"
            Write-Host $msg -ForegroundColor green
        }
        "info" {
            $msg = "$Timestamp - [INFO] - $msg"
            Write-Host $msg -ForegroundColor white
        }
        "cyan" {
            $msg = "$Msg"
            Write-Host $msg -ForegroundColor cyan
        }
        "yellow" {
            $msg = "$Msg"
            Write-Host $msg -ForegroundColor yellow
        }
    }

    Add-Content -Path $LogPath -Value $msg
}
