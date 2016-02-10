function Unprotect-Message {
    [CmdletBinding()]
    Param (
        # Parameter Message
        [Parameter(Mandatory=$true)]
        [String]
        $Message,
        # Parameter FeedbackSize
        $FeedbackSize,
        # Parameter $IV
        $IV = [Byte[]] @(0..15),
        # Parameter Key
        [Parameter(Mandatory=$true)]
        $Key,
        # Paramater KeySize
        $KeySize,
        # Parameter Mode
        [ValidateSet('CBC','ECB','OFB','CFB','CTS')]
        [String] $Mode = 'ECB',
        # Parameter Padding
        [ValidateSet('None','PKCS7','Zeros','ANSIX923','ISO10126')]
        [String] $Padding = 'None',
        # Paramter BlockSize
        $BlockSize,
        # Parameter Base64
        [Switch]
        $Base64
    )
    Begin {
        $AES = New-Object "System.Security.Cryptography.AesManaged" -Property @{
            FeedbackSize = $FeedbackSize
            IV = $IV
            Key = $Key
            KeySize = $KeySize
            Mode = [System.Security.Cryptography.CipherMode]::$Mode
            Padding = [System.Security.Cryptography.PaddingMode]::$Padding
            BlockSize = 128
        }
    }
    Process {
        if ( $Base64 ) {
            $EncryptedMessage = [System.Convert]::FromBase64String($Message)
        } else {
            $EncryptedMessage = $Message
        }

        $bytes = [System.Convert]::FromBase64String($encryptedStringWithIV)
        $IV = $bytes[0..15]
        $aesManaged = Create-AesManagedObject $key $IV
        $decryptor = $aesManaged.CreateDecryptor();
        $unencryptedData = $decryptor.TransformFinalBlock($bytes, 16, $bytes.Length - 16);
        $aesManaged.Dispose()
        [System.Text.Encoding]::UTF8.GetString($unencryptedData).Trim([char]0)

    }
    End {
        $AES.Dispose()
    }
}