<#
.SYNOPSIS
    Function: AddObj

.DESCRIPTION
    EXTENDED NAME:
    Add Object (File or folder)

    DESCRIPTION:
    Depending in the Obj argument the function creates folder or file.
    AddObj function is using CheckObjType function to indicate the extension.
    If the extension at the end of the path is found the file will be created. Otherwise the folder will be created.

.PARAMETER Obj
    Full path to file or folder to create.

.EXAMPLE
    $FileToCreate = Join-Path -Path $Env:SystemDrive -ChildPath "test/file.txt"
    AddObj -Obj $FileToCreate

.EXAMPLE
    AddObj "C:\test1"
    AddObj -Obj "C:\test1"

.NOTES
    PREREQUISITES:
    1) CheckObjType
    2) CrFile
    3) CrFld
    4) Logging function

    REVISION HISTORY:
        ver. 1.00 - 15/01/2020 - Initial version
#>

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

# --- PREREQUISITES --- #

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