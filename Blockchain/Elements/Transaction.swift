//
//  Transaction.swift
//  ZKProofOfConcept
//
//  Created by Ronald "Danger" Mannak on 5/29/19.
//  Copyright © 2019 A Puzzle A Day. All rights reserved.
//

import Foundation

/// This should be a ZK proof with the old state and
public struct Transaction: Codable, Equatable {
 
    /// A hash of all inputs and outputs in this transaction (excluding signatures)
    /// The id guarantees the inputs and output in this transaction have not been altered,
    /// so long as the id is equal to the hashValue of all inputs and outputs.
    public let id: TransactionId
    
    /// Entries owned by sender. In case of multiple inputs,
    /// the inputs will be used in provided order
    let inputs: [Entry]
    
    let amount: uint64
    
    let receivers: [String: UInt64]
    
    // updated entries of both sender and receiver(s)
    fileprivate var outputs: [Entry]?
    
//    let proof: ZKProof
    
    // If false, Transaction uses swift implementation
    let useZK: Bool
    
    init(<#parameters#>) {
        <#statements#>
    }
    
    public init(sender: Address, inputs: [TxInput], outputs: [TxOutput], sign: (Digest) throws -> Signature) throws {
        
        // 1.   Set inputs and outputs
        self.inputs = inputs
        self.outputs = outputs
        
        // 2.   Store address of sender. All outputs referenced
        //      in the inputs property of the transaction must
        //      must be owned by the sender of the transaction.
        self.sender = sender
        
        // 3.   Store the hash value of the inputs and output
        //      (Alternatively, we could not sign the inputs and
        //      outputs separately, but just a single signature
        //      in transaction of the combined hashses.)
        id = Transaction.hash(self.inputs, self.outputs)
        
        // 4.   Sign the hash of the inputs and outputs
        //      If the inputs or outputs are unaltered after signing,
        //      the verified signature is equal to the return value of
        //      the static Transaction.hash:: method.
        //      if the verified signature is not equal
        //      the inputs and outputs have been altered after signing
        //      and the transaction is not valid
        signature = try sign(id)
    }
}

extension Transaction {
    
    func execute() throws {
        
        // If transaction doesn't pass sanity test, there's no need to proceed
        try sanityChecks()
        
        if useZK == true {
            try executeZK()
        } else {
            try executeSwift()
        }
    }
    
    private func executeSwift() throws {
        
        
        var amount = self.amount
        
        for input in inputs {
            
        }
        
        while amount > 0 {
            
            
            
            
        }
        
        guard amount == 0 else {
            throw ZKError.insufficientBalance("Short \(amount) tokens")
        }
        
    }
    
    private func executeZK() throws {
        
    }
    
    private func sanityChecks() throws {
        
        // sanity checks
        // 1. Are all inputs from same type?
        
        // 2. Is balance sufficient?
        let availableBalance = inputs.reduce(0, { $0 + $1.balance })
        guard availableBalance >= self.amount else {
            throw ZKError.insufficientBalance("Short \(self.amount - availableBalance) tokens")
        }
        
        // 3. Are inputs owned by sender?
//        guard

    }

}
