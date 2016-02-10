<#
Write a program in any language you wish that accepts plaintext, a password (either through prompting the user or on the command line), and whether to encrypt or decrypt.
Your program should, if available, use AES with a 128 bit key (derived from the password) in ECB mode to either encrypt or decrypt the plaintext given by the user.
If AES-128-ECB mode is not available, first try to use AES in some other mode, then whatever will work.
In any case, let me know what cipher was used. Print the encrypted output in Base64 to the console.  

A user should be able to run the program to encrypt some text to obtain ciphertext.
The user should be able stop the program and later run the program again and use the same key to decrypt the cipher text.

Using screenshots, show that your program works by encrypting something with one run of the program and decrypting the resulting ciphertext in a second run of the program.


Submit the screenshots and your source code when your program is complete.

Hints:  Do not attempt to implement AES on your own. Instead, use the libraries that come with almost every programming language.
        For example, Java has the Java Cryptography Extensions or the BouncyCastle library, both of which are freely available.  

Do not use the programming language to simply call the OpenSSL command-line programs.
Some languages have bindings to OpenSSL, which are fine to use.

Don't make the program harder than what is specified here.
There is no need for fancy user interfaces or other features.
If your program does what is asked above, it will get full points, even if it does so in an inelegant manner
#>

function Create-AesManagedObject($key, $IV) {
    $aesManaged = New-Object "System.Security.Cryptography.AesManaged"
    $aesManaged.Mode = [System.Security.Cryptography.CipherMode]::ECB
    $aesManaged.Padding = [System.Security.Cryptography.PaddingMode]::Zeros1
    $aesManaged.BlockSize = 128
    $aesManaged.KeySize = 256
    if ($IV) {
        if ($IV.getType().Name -eq "String") {
            $aesManaged.IV = [System.Convert]::FromBase64String($IV)
        }
        else {
            $aesManaged.IV = $IV
        }
    }
    if ($key) {
        if ($key.getType().Name -eq "String") {
            $aesManaged.Key = [System.Convert]::FromBase64String($key)
        }
        else {
            $aesManaged.Key = $key
        }
    }
    $aesManaged
}

function Protect-Message {
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




$key = Create-AesKey
$unencryptedString = "blahblahblah"
$encryptedString = Encrypt-String $key $unencryptedString
Write-Host "Encrypted String: $encryptedString"
$backToPlainText = Decrypt-String $key $encryptedString
Write-Host "Decrypted String: $backToPlainText"