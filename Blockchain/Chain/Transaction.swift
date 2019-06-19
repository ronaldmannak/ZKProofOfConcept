//
//  Transaction.swift
//  ZKProofOfConcept
//
//  Created by Ronald "Danger" Mannak on 5/29/19.
//  Copyright © 2019 A Puzzle A Day. All rights reserved.
//

import Foundation

public struct Transaction: Codable, Equatable, Sha256Hashable {
    
    public struct TransactionMessage: Codable, Equatable, Sha256Hashable {
        
        /// Counters used for protection against double-application of payments.
        /// The account nonce is incremented in the sender's account whenever
        /// a transaction is created.
        /// Each nonce should match the input Entry used, in order
        public let nonces: [UInt64]
        
        /// Entries owned by sender. In case of multiple inputs,
        /// the inputs will be used in provided order
        /// Inputs are *not* checked for valid predicates
        public let inputs: [Entry]
        
        let outputs: [Entry]
        
        public let type: ContractAddress
        
        public let recipients: [Recipient]
        
        public let sender: AccountAddress
        
        public let fee: UInt64 = 0
    
        public var sha256: Sha256Hash {
            return try! JSONEncoder().encode(self).sha256
        }
    }
    
    public let message: TransactionMessage
 
    /// A hash of the transaction message
    /// The id guarantees the inputs and output in this transaction have not been altered,
    /// so long as the id is equal to the hashValue of all inputs and outputs.
    public let id: TransactionId
    
    /// Single signature of the transaction's hash
    /// The signature guarantees the inputs and outputs are unaltered,
    public let signature: Signature
    
    public let sha256: Sha256Hash
    
    fileprivate init(message: TransactionMessage, sender: Account, inputs: [Entry], outputs: [Entry]) throws {
        
        self.message = message
        self.id = message.sha256
        self.signature = try sender.sign(self.id)
        self.sha256 = message.sha256
    }
}

extension Transaction {
    
    /// <#Description#>
    ///
    /// A transaction fetches all spendable entries from sender of type type
    /// It then uses
    
    /// - Parameters:
    ///   - sender: <#sender description#>
    ///   - type: <#type description#>
    ///   - recipients: <#recipients description#>
    ///   - block: <#block description#>
    ///   - blockData: <#blockData description#>
    ///   - sign: <#sign description#>
    public static func create(sender: Account, type: ContractAddress, recipients: [Recipient], block: Block, blockData: BlockData, result: @escaping (Transaction?, Error?) -> Void)  {
        
        // 1. Sanity check. Validate block and blockData
        guard block.quickValidate(blockData: blockData) else {
            result(nil, ZKError.invalidBlock)
            return
        }
        
        // 2. Fetch all entries of type type and owned by sender
        let inputs = blockData.balances.filter{ $0.owner == sender.address && $0.type == type }
        
        // 3. Run predicate on each entry and filter out the ones that returned false
        Entry.filterSpendable(block: block, blockData: blockData, entries: inputs) { spendableInputs in
            
            // 4. Does sender have enough tokens?
            let needed = recipients.reduce(UInt64(0), { $0 + $1.amount })
            let available = spendableInputs.reduce(UInt64(0), { $0 + $1.balance })
            guard available >= needed else {
                result(nil, ZKError.insufficientFunds(available, needed))
                return
            }
            guard needed > 0 else {
                result(nil, ZKError.transactionError)
                return
            }
            
            // 5. Use entries to pay recipients
            var outputs = [Entry]()
            var spendableInputs = spendableInputs
            
            for recipient in recipients {
                
                var amount = recipient.amount
                
                while amount > 0 {
                    
                    let spentInput = spendableInputs.removeFirst()
                    let output: Entry
                    if amount > spentInput.balance {
                        
                        // Balance of input is less than needed, use multiple inputs for this transaction
                        output = Entry(owner: recipient.to, balance: spentInput.balance, type: type, spendPredicate: spentInput.spendPredicate, spendPredicateArguments: spentInput.spendPredicateArguments, data: spentInput.data, nonce: 0, previousHash: spentInput.sha256)
                        
                        amount = amount - spentInput.balance
                        
                    } else {
                        
                        // Balance of input is more than needed, only current input
                        output = Entry(owner: recipient.to, balance: amount, type: type, spendPredicate: spentInput.spendPredicate, spendPredicateArguments: spentInput.spendPredicateArguments, data: spentInput.data, nonce: 0, previousHash: spentInput.sha256)
                        
                        if amount != spentInput.balance {
                        
                            // Change
                            let changeAmount = spentInput.balance - amount
                            let change = Entry(owner: spentInput.owner, balance: changeAmount, type: spentInput.type, spendPredicate: spentInput.spendPredicate, spendPredicateArguments: spentInput.spendPredicateArguments, data: spentInput.data, nonce: spentInput.nonce, previousHash: spentInput.sha256)
                            spendableInputs.insert(change, at: 0)
                        }
                        
                        amount = 0
                    }
                    outputs.append(output)
                }
            }
            
//            outputs.append(contentsOf: spendableInputs)
            
            // 6. Create transaction
            let message = Transaction.TransactionMessage(nonces: [UInt64](), inputs: inputs, outputs: outputs + spendableInputs, type: type, recipients: recipients, sender: sender.address)
            do {
                let tx = try Transaction(message: message, sender: sender, inputs: inputs, outputs: outputs)
                result(tx, nil)
            } catch {
                result(nil, error)
            }
        }
    }
}
