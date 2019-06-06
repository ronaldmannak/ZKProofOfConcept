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
    public static func hash(_ inputs: [TxInput], _ outputs: [TxOutput], proof: ZKProof) -> Data {
        return [inputs.sha256, outputs.sha256].sha256
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
        return try key.verify(signature: signature, digest: Transaction.hash(inputs, outputs))
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
        return "\n\ntxId: ...\(id.hexDescription.suffix(4)), sender: ...\(sender.hexDescription.suffix(4)), \ninputs: \(inputs) \noutputs: \(outputs)"
    }
}
