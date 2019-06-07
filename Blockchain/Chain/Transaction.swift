//
//  Transaction.swift
//  ZKProofOfConcept
//
//  Created by Ronald "Danger" Mannak on 5/29/19.
//  Copyright © 2019 A Puzzle A Day. All rights reserved.
//

import Foundation

public struct Transaction: Codable, Equatable {
    
    public struct TransactionMessage: Codable, Equatable, Sha256Hashable {
        
        /// Counter
        public let nonce: UInt64
        
        /// Entries owned by sender. In case of multiple inputs,
        /// the inputs will be used in provided order
        /// Inputs are *not* checked for valid predicates
        public let inputs: [Entry]
        
        public let type: ContractAddress
        
        public let recipients: [Recipient]
        
        let sender: AccountAddress
        
        public var sha256: Sha256Hash {
            return try! JSONEncoder().encode(self).sha256
        }
    }
    
    public let message: TransactionMessage
 
    /// A hash of all inputs and outputs in this transaction (excluding signatures)
    /// The id guarantees the inputs and output in this transaction have not been altered,
    /// so long as the id is equal to the hashValue of all inputs and outputs.
    public let id: TransactionId
    
    /// Single signature of the transaction's hash
    /// The signature guarantees the inputs and outputs are unaltered,
    public let signature: Signature
    
    
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - sender: <#sender description#>
    ///   - amount: <#amount description#>
    ///   - type: <#type description#>
    ///   - recipients: <#recipients description#>
    ///   - block: <#block description#>
    ///   - blockData: <#blockData description#>
    ///   - sign: <#sign description#>
    init(sender: AccountAddress, amount: UInt64, type: ContractAddress, recipients: [Recipient], block: Block, blockData: BlockData, sign: (Digest) throws -> Signature) throws {
        
        // 1. Set nonce
        
        // 1. Fetch inputs owned by sender of the correct type.
        //    Quickfetch fetches all entries, including locked ones.
        //    When the proof is generated, this will get validated
        let inputs = blockData.quickFilterEntries(owner: sender, type: type)
        
        // 2. Set message
        self.message = TransactionMessage(nonce: 1, inputs: inputs, type: type, recipients: recipients, sender: sender)
        
        // 3. Set transaction id to hash of message
        self.id = self.message.sha256
        
        // 4. Sign message
        self.signature = try sign(self.id)
        
    }
 
}


