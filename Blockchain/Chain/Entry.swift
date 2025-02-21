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
    
    public let type: ContractAddress
    
    ///
    public let spendPredicate: Predicate? // Or address in contract address space
    public let spendPredicateArguments: [String]?
    
    ///
//    public let receivePredicate: Predicate
//    public let receivePredicateArguments: [String]?
    
    public let data: Data?
    
    /// Counter used for protection against double-application of payments
    public let nonce = UUID()
    
    /// Do we need that?
    public let previousHash: Sha256Hash?
}

extension Entry {

    /// <#Description#>
    ///
    /// - Parameters:
    ///   - block: <#block description#>
    ///   - blockData: <#blockData description#>
    ///   - entries: <#entries description#>
    ///   - result: <#result description#>
    public static func filterSpendable(block: Block, blockData: BlockData, entries: [Entry], result: @escaping ([Entry]) -> Void) {
        
        DispatchQueue.global().async {
            let filterGroup = DispatchGroup()
            var filtered = [Entry]()
            
            for entry in entries {

                filterGroup.enter()
                
                entry.isSpendable(block: block, blockData: blockData, result: { result, error in
                    if result == true { filtered.append(entry) }
                })
                
                filterGroup.leave()
            }
            
            filterGroup.wait()
            
            DispatchQueue.main.async {
                result(filtered)
            }
        }
    }
    
    
    public static func filterReceivables(block: Block, blockData: BlockData, receivers: [Entry], result: @escaping ([Entry]) -> Void) {
    }
}

extension Entry: Sha256Hashable, Codable, Equatable {
    
    public var sha256: Sha256Hash {
        return try! JSONEncoder().encode(self).sha256
    }
}

extension Entry: CustomStringConvertible {
    public var description: String {
        return "owner: ..." + owner.hexDescription.suffix(4) + ", balance: \(balance), nonce: \(nonce), hash: \(sha256.hexDescription.suffix(4)), previous: \(previousHash?.hexDescription.suffix(4) ?? "(genesis)")\n"
    }
}
