//
//  Transaction+validation.swift
//  ZKProofOfConcept
//
//  Created by Ronald "Danger" Mannak on 5/29/19.
//  Copyright © 2019 A Puzzle A Day. All rights reserved.
//

import Foundation

// Validation
extension Transaction {
    
    /**
     Creates a hash of the inputs and outputs of the inputs and outputs
     in the transaction. The hash is used for the signing the transaction.
     - parameter inputs:        Array of the inputs in the transaction.
     - parameter outputs:       Array of the outputs in the transaction.
     */
    public static func hash(inputs: [Entry], recipients: [Recipient]) -> Data {
        return [inputs.sha256, recipients.sha256].sha256
    }
    
    /**
     Validates that the signature was signed by sender and that the
     inputs and outputs are unaltered by comparing the signed hash with
     a computed hash value.
     - returns:     True if the signature is
     - throws:      Forwards error from Apple's encryption framework
     */
    public func isUnaltered() throws -> Bool {
        let key = try Key(from: sender)
        return try key.verify(signature: signature, digest: Transaction.hash(inputs: inputs, recipients: recipients))
    }
    
    /**
     Checks if the transaction is a genesis transaction.
     - returns:     true if the transaction is a genesis transaction
     */
    public var isGenesisTransaction: Bool {
        guard inputs.count == 0, outputs.count == 1 else { return false }
        guard sender == Data(), signature == Data() else { return false }
        return true
    }
}

// Sha256
extension Transaction: Sha256Hashable {
    public var sha256: Sha256Hash {
        return try! JSONEncoder().encode(self).sha256
    }
}

extension Transaction: CustomStringConvertible {
    public var description: String {
        return "\n\ntxId: ...\(id.hexDescription.suffix(4)), sender: ...\(sender.suffix(4)), \ninputs: \(self.inputs) \noutputs: \(self.recipients)"
    }
}

extension Transaction {
    
    private func sanityCheck() throws {
        
        // 1. Are all inputs owned by sender?
        let publicKey = try Key(from: sender).exportKey()
        guard inputs.filter({ $0.owner == publicKey }).count == inputs.count else {
            throw ZKError.inputsNotOwnedBySender
        }
        
        // 2. Is balance sufficient?
        // TODO: calculate spendable amount (check predicates)
        let availableBalance = self.inputs.reduce(0, { $0 + $1.balance })
        let spentAmount = self.outputs.reduce(0, { $0 + $1.balance })

        guard availableBalance >= spentAmount else {
            throw ZKError.insufficientBalance("Short \(spentAmount - availableBalance) tokens")
        }
        
        // 3. Are no new coins generated?
        
        // 3. Are outputs correct?
        
    }
    
}
