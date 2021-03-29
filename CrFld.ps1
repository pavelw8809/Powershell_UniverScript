Function CrFld {
    param(
        [Parameter(Position=0)]
        [string]$Fld
    )

    if (!(Test-Path $Fld)) {
        try {
            Write-Log -type 4 -msg "Creating folder: $($Fld)"
            New-Item -ItemType Directory -Path $Fld -Force
        }
        catch {
            Write-Log -type 2 -msg "ERROR - The folder: $($Fld) could not be created."
        }
    }
}
