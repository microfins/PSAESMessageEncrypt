Foreach ( $Script in @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue ) ) {
    Try { . $Script.FullName }
    Catch { Write-Error -Message "Failed to import function $($Script.FullName): $_" }
}