//
//  Entry.swift
//  ZKProofOfConceptTests
//
//  Created by Ronald "Danger" Mannak on 5/29/19.
//  Copyright © 2019 A Puzzle A Day. All rights reserved.
//

import Foundation

public enum EntryType: Int, Codable, Equatable {
    case fungible = 0, nonFungible
}

public struct Entry: Codable, Equatable {
    
    public let balance: uint64 // balance or amount
    
    public let entryType: EntryType
    
    public let publicKey: Sha256Hash
    
    public let spendPredicate: Predicate // Or address in contract address space
    
    public let spendPredicateArguments: [String: String]
    
    public let data: Data
    
//    let proof: ZKProof
}
