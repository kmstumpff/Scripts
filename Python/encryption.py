#!/usr/bin/python2.7

from os import urandom

def vernam_genkey(length):
    """Generating a key"""
    return bytearray(urandom(length))

def vernam_encrypt(plaintext, key):
    """Encrypting the message.
Read more on XOR encryption on http://en.wikipedia.org/wiki/XOR_cipher
"""
    return bytearray([ord(plaintext[i]) ^ key[i] for i in xrange(len(plaintext))])

def vernam_decrypt(ciphertext, key):
    """Decrypting the message
Read more on XOR encryption on http://en.wikipedia.org/wiki/XOR_cipher
"""
    return bytearray([ciphertext[i] ^ key[i] for i in xrange(len(ciphertext))])

def main():
    myMessage = """This is a topsecret message..."""
    print ('message:',myMessage)
    key = vernam_genkey(len(myMessage))
    print 'key:', str(key)
    cipherText = vernam_encrypt(myMessage, key)
    print 'cipherText:', str(cipherText)
    print 'decrypted:', vernam_decrypt(cipherText,key)
    
    if vernam_decrypt(vernam_encrypt(myMessage, key),key)==myMessage:
        print ('Unit Test Passed')
    else:
        print('Unit Test Failed - Check Your Python Distribution')

if __name__ == '__main__':
    main()
