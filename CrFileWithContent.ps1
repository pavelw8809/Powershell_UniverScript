Function CrFileWithContent {
    param(
        [Parameter(Position=0)]
        [string]$File,
        [Parameter(position=1)]
        [string[]]$Content #Array of lines
    )

    CrFile $File
    ForEach ($item in $Content) {
        Write-Log -Type 4 -msg "Writing line: $($item) to $($file)"
        Add-Content -Value $item -Path $File
    }
}