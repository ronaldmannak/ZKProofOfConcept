//
//  TransactionProof.swift
//  ZKProofOfConcept
//
//  Created by Ronald "Danger" Mannak on 6/6/19.
//  Copyright © 2019 A Puzzle A Day. All rights reserved.
//

import Foundation

/// Proves that the transaction itself was valid and that state transition was valid
public struct TransactionProof {
    
    let transaction: Transaction
    
    let sha256: Sha256Hash!
    
    // updated entries of both sender and receiver(s)
    public let outputs: [Entry]
    
    let proof: ZKProof
    
    // If false, Transaction uses swift implementation
    let useZK: Bool

    public func validate(result: (Bool) -> Void) {
        
        // If zero knowledge is bypassed, just return true
        guard useZK == true else {
            result(true)
            return
        }
        
        result(false)
    }
    
    public static func createProof(transaction: Transaction, useZK: Bool = true, result: (TransactionProof) -> Void) {
    
        
    }
}

extension TransactionProof: Codable, Equatable {}
