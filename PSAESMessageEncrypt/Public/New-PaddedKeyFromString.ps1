function New-PaddedKeyFromString {
    [CmdletBinding()]
    Param (
        # Parameter Message
        [Parameter(Mandatory=$true)]
        [String]
        $String,
        # Parameter Bytes
        [Int]
        $Bytes
    )
    Begin {}
    Process {
        try {
            if ( $String.Length -gt $Bytes ) {
                $Substring = $String.Substring(0,$Bytes - 1)
                Write-Warning "String is too long. String '$String' will be truncated to '$Substring'."
                $String = $Substring
            }
            $Array = [System.Text.Encoding]::UTF8.GetBytes($String)
            While ( $Array.Count -lt $Bytes ) {
                $Array += 0
            }
            return $Array
        }
        catch {
            Write-Error $_
        }
    }
    End {}
}