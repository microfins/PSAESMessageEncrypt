# Probably should have signed the script and functions, but since I am not so nice I set the script execution policy to unrestricted
Set-ExecutionPolicy -ExecutionPolicy Unrestricted

# Import the module
Import-Module $PSScriptRoot\..\PSAESMessageEncrypt -Force
Get-Module PSAESMessageEncrypt
Write-Output ''

# Create a key
[Byte[]] $Key = New-PaddedKeyFromString -String 'SecretPassword' -Bytes 16
Write-Output "Key`n---"
Write-Output ( $Key -join ',' )
Write-Output ''

# Create a IntializationVector
[Byte[]] $IntializationVector = New-PaddedKeyFromString -String 'ThisIsIVThisIsIV' -Bytes 16
Write-Output "IntializationVector`n-------------------"
Write-Output ( $IntializationVector -join ',' )
Write-Output ''

# Define a message
[String[]] $PlaintextMessage = 'This is plaintext message 1','This is plaintext message 2','This is plaintext message 3'
Write-Output "Messages`n--------"
Write-Output $PlaintextMessage
Write-Output ''

# Encrypt the message
[String[]] $EncryptedMessage = Protect-Message -Message $PlaintextMessage -Key $Key -InitializationVector $IntializationVector
Write-Output "EncryptedMessages`n-----------------"
Write-Output $EncryptedMessage
Write-Output ''

# Descrypt the message
[String[]] $DecryptedMessage = Unprotect-Message -Message $EncryptedMessage -Key $Key -InitializationVector $IntializationVector
Write-Output "DecryptedMessages`n-----------------"
Write-Output $DecryptedMessage

<#
Sample Output:

ModuleType Version    Name                                ExportedCommands                                                                                                                    
---------- -------    ----                                ----------------                                                                                                                    
Script     0.0.1      PSAESMessageEncrypt                 {New-PaddedKeyFromString, Protect-Message, Unprotect-Message}                                                                       

Key
---
83,101,99,114,101,116,80,97,115,115,119,111,114,100,0,0

IntializationVector
-------------------
84,104,105,115,73,115,73,86,84,104,105,115,73,115,73,86

Messages
--------
This is plaintext message 1
This is plaintext message 2
This is plaintext message 3

EncryptedMessages
-----------------
YLAptGJlDjeAkkaLTj8CKCXq74U9qO0H7zrY3G4bx0s=
YLAptGJlDjeAkkaLTj8CKH1186i2FyMGAKhBIjv37aM=
YLAptGJlDjeAkkaLTj8CKC5nrc02vikkp3SEpq/HEQQ=

DecryptedMessages
-----------------
This is plaintext message 1
This is plaintext message 2
This is plaintext message 3
#>