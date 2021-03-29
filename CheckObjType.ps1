Function CheckObjType {
    param(
        [Parameter(Position=0)]
        [string]$Obj
    )

    Write-Log -type 4 -msg "Checking object: $($Obj)"

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