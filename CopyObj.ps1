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
            Write-Log -type 4 -msg "Creating destination path: $($Dest)"
            CrFld $Dest
        }

        if ($Overwrite -eq "ov") {
            if (Test-Path $ObjToCopy) {
                if (!(Test-Path $Dest)) {
                    Write-Log -type 4 -msg "Creating destination path: $($Dest)"
                    CrFld $Dest
                }
                try {
                    Write-Log -type 4 -msg "Copying files - FROM: $($ObjToCopy) TO: $($Dest)"
                    Copy-Item $ObjToCopy $Dest -Force
                } 
                catch {
                    Write-Log -type 2 -msg "Copying to path: $($Dest) failed"
                }
            } else {
                Write-Log -type 1 -msg "Nothing to copy"
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
                            Write-Log -type 4 -msg "Copying object: $($item) TO: $($Dest)"
                            Copy-Item $ftocopy $Dest -Recurse -Force
                        } 
                        catch {
                            Write-Log -type 2 -msg "Copying to path: $($Dest) failed"
                        }
                    } else {
                        Write-Log -type 1 -msg "Object: $($fname) already exists in $($Dest)"
                    }
                }
            } else {
                $fname = Split-Path $objToCopy -Leaf
                $fcheck = Join-Path -Path $Dest -ChildPath $fname
                if (!(Test-Path $fcheck)) {
                    try {
                        Write-Log -type 4 -msg "Copying object: $($objToCopy) TO: $($Dest)"
                        Copy-Item $objToCopy $Dest -Recurse -Force
                    } 
                    catch {
                        Write-Log -type 2 -msg "Copying to path: $($Dest) failed"
                    }
                } else {
                    Write-Log -type 1 -msg "Object: $($fname) already exists in $($Dest)"
                }
            }
        }
    } else {
        Write-Log -type 1 -msg "Object to copy: $($ObjToCopy) was not found. Nothing to copy"
    }
}