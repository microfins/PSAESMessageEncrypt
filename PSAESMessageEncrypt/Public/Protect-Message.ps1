﻿function Protect-Message {
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
        $MessageBytes = [System.Text.Encoding]::UTF8.GetBytes($Message)
        $Encryptor = $AES.CreateEncryptor()
        [Byte[]] $EncryptedMessage = $AES.IV + $encryptor.TransformFinalBlock($MessageBytes, 0, $MessageBytes.Length)
        if ( $Base64 ) {
            return [System.Convert]::ToBase64String($EncryptedMessage)
        } else {
            return $EncryptedMessage
        }
    }
    End {
        $AES.Dispose()
    }
}