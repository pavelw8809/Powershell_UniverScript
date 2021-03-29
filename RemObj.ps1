Function RemObj {
    param (
        [Parameter(Position=0)]
        [string]$Object
    )

    if (Test-Path -Path $Object) {
        Try {
            Write-Log -type 4 -msg "Deleting object: $Object"
            Remove-Item $Object -Recurse -Force
        } Catch {
            Write-Log -type 2 -msg "Object: $Object was not successfully removed"
        }
    }
}