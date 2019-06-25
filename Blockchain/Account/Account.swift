//
//  Account.swift
//  NaiveSwiftCoin
//
//  Created by Ronald Mannak on 4/23/18.
//  Copyright © 2018 A Puzzle A Day. All rights reserved.
//

import Foundation

/**
 Account
 */
public struct Account {
    
    /// User defined, human readable name of the account
    public var name:            String
    
    /// Public key in Data format
    public let address:         AccountAddress
    
    /// Human readable public key address
    public var publicKey:       String {
        return address.hexDescription
    }
    
    /// Queued transactions
    fileprivate (set) var transactions = [ContractAddress: (Transaction, TransactionProof)]()
    
    /// Key management
    fileprivate let key:        Key
    
    /// Id label to use, store and retrieve the public and private keys
    public let uuid: UUID
    
    /**
     Initializes a new account. Invoked by Wallet.
     - parameter name:          Human readable name of the account
     provided by the owner. If no name is
     provided, a UUID will be used. The
     name can be changed later
     */
    public init(named name: String) throws {
        
        self.name =             name
        uuid =                  UUID()
        key =                   try Key(with: uuid, prompt: "Sign transaction")
        address =               try key.exportKey()
    }
}


// Transactions
extension Account {
    
    public func createTx(type: ContractAddress, recipients: [Recipient], block: Block, blockData: BlockData, replaceIfNeeded: Bool = false, result: @escaping (Transaction?, TransactionProof?, Error?) -> Void) {
        
        Transaction.create(sender: self, type: type, recipients: recipients, block: block, blockData: blockData) { (tx, error) in
            
            guard error == nil else {
                result(nil, nil, error!)
                return
            }
            
            // TODO: Generate proof
            
            result(tx, nil, nil)
            
            
            // 1.  There can only be one of each type per block. If user tries
//            guard self.transactions[type] == nil || self.replaceIfNeeded == true else {
//                throw ZKError.moreThanOneTx
//                return
//            }
            
            // 2. Add to transactions
//            self.transactions[type] = ($0)
        }
    }
    
    public func propagateTx() {
        
        // 1. Create proof
//        TransactionProof.createProof(transaction: transaction, useZK: false) { self.transactions?.append(<#T##newElement: (Transaction, TransactionProof)##(Transaction, TransactionProof)#>)
//        }
    }
}

// Balance
extension Account {
    
    /**
     Returns the spendable amount of address
     - parameter blockchain: The blockchain address is part of
     - returns: the total amount of all utxos in the blockchain minus any
     inputs in the queue that reference an output owned by address
     */
//    func balance(blockchain: Blockchain) -> Amount {
//        return blockchain.balance(of: address)
//    }
}

// Signs and encrypt
extension Account {
    
    public func sign(_ digest: Data) throws -> Signature {
        
        return try self.key.sign(digest)
    }
    
    public func verify(signature: Signature, digest: Data) -> Bool {
        
        do {
            return try self.key.verify(signature: signature, digest: digest)
        } catch {
            return false
        }
    }
    
    public func encrypt(_ data: Data) -> Data? {
        
        do {
            return try self.key.encrypt(data)
        } catch {
            return nil
        }
    }
    
    public func decrypt(_ cipherText: Data) -> Data? {
        
        do {
            return try self.key.decrypt(cipherText)
        } catch {
            return nil
        }
    }    
}

extension Account: CustomStringConvertible {
    public var description: String {
        return "\(name) (...\(address.hexDescription.suffix(4))"
    }
}
