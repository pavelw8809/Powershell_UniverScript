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
            Write-Log -type 4 -msg "Creating file: $($File)"
            New-Item -Path $File -ItemType "file" -Force 
        }
        catch {
            Write-Log -type 2 -msg "ERROR - The file: $($FileName) could not be created in: $($FilePath)."
        }
    }
}