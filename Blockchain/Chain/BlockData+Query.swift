//
//  BlockData+Query.swift
//  ZKProofOfConcept
//
//  Created by Ronald "Danger" Mannak on 6/6/19.
//  Copyright © 2019 A Puzzle A Day. All rights reserved.
//

import Foundation

extension BlockData {
    
    public func quickFilterEntries(owner: AccountAddress, type: ContractAddress) -> [Entry] {
        
        return self.balances.filter{ $0.owner == owner && $0.type == type }
    }
    
    public func filterEntries(owner: AccountAddress, type: ContractAddress, spendable: Bool = true, result: ([Entry]) -> Void) {
        
        let quickfiltered = self.quickFilterEntries(owner: owner, type: type)
        
        // TODO: run predicates
        
        result(quickfiltered)        
    }
    
}

// Query balances
extension BlockData {
    
    public func entries(for address: AccountAddress) -> [Entry]? {
        
        return self.balances.filter { $0.owner == address }
    }
    
    public func balances(for address: AccountAddress) -> (UInt64, [Entry]?) {
        
        guard let entries = self.entries(for: address)?.filter({ $0.owner == address }) else {
            return (0, nil)
        }
        
        let balance = entries.reduce(0) { $0 + $1.balance }
        
        // TODO: What about spent entries?
        
        return (balance, entries)
    }
    
}
