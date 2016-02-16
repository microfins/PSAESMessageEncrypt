function Unprotect-Message {
<#
.Synopsis
   Unencyrpts a message
.DESCRIPTION
   Unencrypts a base64 message when a string, key, and initialization vector are provided. 
.EXAMPLE
   Unprotect-Message -Message 'yDqG4hBLvxEeWXO8oTS4B9tTHRygrIsxucDzcIgqJBY=' -Key @(0..15) -InitializationVector @(16..31)
.Notes
    (c) 2016 Shawn Esterman. All rights reserved.
#>       
    [CmdletBinding()]
    Param (
        # Parameter Message
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true)]
        [String[]]
        $Message,
        # Parameter Key
        [Parameter(Mandatory=$true)]
        [Byte[]]
        $Key,
        # Parameter $IV
        [Byte[]]
        $InitializationVector,
        # Paramter BlockSize
        $BlockSize = 128,
        # Parameter Mode
        [ValidateSet('CBC','ECB','OFB','CFB','CTS')]
        [String] $Mode = 'ECB',
        # Parameter Padding
        [ValidateSet('None','PKCS7','Zeros','ANSIX923','ISO10126')]
        [String] $Padding = 'PKCS7',
        # Parameter Base64
        [Switch]
        $Base64
    )
    Begin {
        # Create AESManaged Object
        $AES = New-Object 'System.Security.Cryptography.AesManaged' -Property @{
            Mode = [System.Security.Cryptography.CipherMode]::$Mode
            Padding = [System.Security.Cryptography.PaddingMode]::$Padding
        }

        # Confirm BlockSize is valid for the mode
        if ( $BlockSize -le $AES.LegalBlockSizes.MinSize -and $BlockSize -gt $AES.LegalBlockSizes.MaxSize ) {
            Write-Error "BlockSize is not valid for this mode."
            $AES.Dispose()
            return
        } else {
            # Passed, set values
            $AES.BlockSize = $BlockSize
        }

        # If no IV provided, use array of 1 through number of entries in $Key
        # If no IV is provided for both protect and unprotect, functionality will still work
        if ( $InitializationVector -eq $null ) { 
            $InitializationVector = @(1..$Key.Count)
        }
        
        # Key keysizes in bits
        $KeySize = $Key.Count * 8
        $InitializationVectorSize = $InitializationVector.Count * 8

        # Confirm that Key and IV size are the same
        if ( $KeySize -ne $InitializationVectorSize ) {
            Write-Error "KeySize does not match IVSize. Exiting."
            $AES.Dispose()
            return
        }

        # Check for valid key size
        if ( $KeySize -le $AES.LegalKeySizes.MinSize -and $KeySize -gt $AES.LegalKeySizes.MaxSize ) {
            Write-Error "KeySize is not valid for this mode."
            $AES.Dispose()
            return
        } else {
            # Passed, set values
            $AES.Key = $Key
            $AES.IV = $InitializationVector
        }

        # Create encryptor once values are set
        $Decryptor = $AES.CreateDecryptor()
    }
    Process {
        foreach ( $M in $Message ) {
            $EncryptedMessage = [System.Convert]::FromBase64String($M)
            $UnencryptedMessage = $Decryptor.TransformFinalBlock($EncryptedMessage, 0, $EncryptedMessage.Length);
            $UnencryptedMessage = [System.Text.Encoding]::UTF8.GetString($UnencryptedMessage).Trim([char]0)
            Write-Output $UnencryptedMessage
        }
    }
    End {
        $Decryptor.Dispose()
        $AES.Dispose()
    }
}