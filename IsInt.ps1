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