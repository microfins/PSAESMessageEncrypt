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
