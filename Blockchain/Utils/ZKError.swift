//
//  ZKError.swift
//  ZKProofOfConcept
//
//  Created by Ronald "Danger" Mannak on 5/29/19.
//  Copyright © 2019 A Puzzle A Day. All rights reserved.
//

import Foundation

public enum ZKError: LocalizedError {
    
    // Transaction errors
    case inputsNotOwnedBySender
    
    case multipleEntryTypes
    
    case nonceError
    
    case insufficientBalance(String)
    
    /// (available, needed)
    case insufficientFunds(UInt64, UInt64)
    
    case transactionError
    
    case moreThanOneTx
    
    /// TxInput references to an invalid TxOutput
    case invalidReference(Entry)
    
    case invalidBlock
    
    // Key
    
    /// The provided private key label is invalid
    case invalidPrivateKeyLabel(String)
    
    /// Could not serialize string to utf8 data
    case serialization(String)
    
    case invalidPublicKey(Data)
    
    case invalidPublicKeyString(String)
    
    /// Crypto needs a private key to sign and decode
    /// If no private key was found (because Crypto
    /// was initialized with only a stored public key)
    /// Crypto will throw a noPrivateKey error
    case noPrivateKey
    
    case errorCreatingPublicKey
    
    case encryptionError
    
    case verificationError
    
    /// Data too large to encrypt or not correct size to decrypt
    case sizeError

}
