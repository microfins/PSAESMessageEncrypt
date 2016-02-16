## PSAESEncryptMessage ##

This is a rudimentary PowerShell module for encrypting messages with AES.

This module uses .Net classes to encrypt a message. 

## Installation ##

- Download repository from [GitHub](https://github.com/shwnstrmn/PSAESMessageEncrypt)
- Run PowerShell or PowerShell ISE as administrator
- Set execution policy to unrestricted `Set-ExecutionPolicy Unrestricted`
- Run the following command to import the module `Import-Module .\PSAESMessageEncrypt\PSAESMessageEncrypt -Force`

## Demo ##

There is a demo located at .\Tests\Demo.ps1 which can be used to demonstrate how the module can be used.

The sample output is as follows:

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


## Notes ##
Since the module is downloaded from the internet. Some operating systems may require you to unlock the files before running. Actually, PowerShell is for Windows and Windows will most likely make you do this so my statement is irrelevant. 

(c) 2016 Shawn Esterman. All rights reserved. 