//
//  Transaction.swift
//  ZKProofOfConcept
//
//  Created by Ronald "Danger" Mannak on 5/29/19.
//  Copyright © 2019 A Puzzle A Day. All rights reserved.
//

import Foundation

public struct Transaction: Codable, Equatable {
 
    /// A hash of all inputs and outputs in this transaction (excluding signatures)
    /// The id guarantees the inputs and output in this transaction have not been altered,
    /// so long as the id is equal to the hashValue of all inputs and outputs.
    public let id: TransactionId
    
    /// Entries owned by sender. In case of multiple inputs,
    /// the inputs will be used in provided order
    public let inputs: [Entry]
    
    public let recipients: [Recipient]
    
    // updated entries of both sender and receiver(s)
    public let outputs: [Entry]
    
    let sender: AccountAddress
    
    /// Single signature of the transaction's hash
    /// The signature guarantees the inputs and outputs are unaltered,
    public let signature: Signature
        
    public init(sender: AccountAddress, inputs: [Entry], recipients: [Recipient], sign: (Digest) throws -> Signature) throws {
        
        // 1.   Set inputs and receivers
        self.inputs = inputs
        self.recipients = recipients
        
        // 2.   Store address of sender. All outputs referenced
        //      in the inputs property of the transaction must
        //      must be owned by the sender of the transaction.
        self.sender = sender
        
        // 3.   Store the hash value of the inputs and output
        //      (Alternatively, we could not sign the inputs and
        //      outputs separately, but just a single signature
        //      in transaction of the combined hashses.)
        id = Transaction.hash(inputs: self.inputs, recipients: self.recipients)
        
        // 4.   Sign the hash of the inputs and outputs
        //      If the inputs or outputs are unaltered after signing,
        //      the verified signature is equal to the return value of
        //      the static Transaction.hash:: method.
        //      if the verified signature is not equal
        //      the inputs and outputs have been altered after signing
        //      and the transaction is not valid
        signature = try sign(id)
        
        
        // create outputs
    }
}


