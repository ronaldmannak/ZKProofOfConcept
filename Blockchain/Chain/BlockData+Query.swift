//
//  BlockData+Query.swift
//  ZKProofOfConcept
//
//  Created by Ronald "Danger" Mannak on 6/6/19.
//  Copyright © 2019 A Puzzle A Day. All rights reserved.
//

import Foundation

extension BlockData {
    
    func quickFilterEntries(owner: AccountAddress, type: ContractAddress) -> [Entry] {
        
        return self.balances.filter{ $0.owner == owner && $0.type == type }
    }
    
    func filterEntries(owner: AccountAddress, type: ContractAddress, spendable: Bool = true, result: ([Entry]) -> Void) {
        
        let quickfiltered = self.quickFilterEntries(owner: owner, type: type)
        
        // TODO: run predicates
        
        result(quickfiltered)        
    }
    
}
