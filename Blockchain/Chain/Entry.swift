//
//  Entry.swift
//  ZKProofOfConceptTests
//
//  Created by Ronald "Danger" Mannak on 5/29/19.
//  Copyright © 2019 A Puzzle A Day. All rights reserved.
//

import Foundation

// Move to contract
//public enum EntryType: Int, Codable, Equatable {
//    case fungible = 0, nonFungible
//}

public struct Entry {
    
    public let owner: AccountAddress
    
    public let balance: uint64 // balance or amount
    
//    public let entryType: EntryType
    
    public let type: ContractAddress
    
    public let spendPredicate: Predicate // Or address in contract address space
    
    public let spendPredicateArguments: [String: String]?
    
    public let data: Data?
    
    /// Counter used for protection against double-application of payments
    public var nonce: UInt64
}

extension Entry: Sha256Hashable, Codable, Equatable {
    
    public var sha256: Sha256Hash {
        return try! JSONEncoder().encode(self).sha256
    }
}

extension Entry: CustomStringConvertible {
    public var description: String {
        return "to: ..." + owner.hexDescription.suffix(4) + ", balance: \(balance)"
    }
}
