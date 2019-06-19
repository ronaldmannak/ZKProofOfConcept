//
//  BlockData+Validation.swift
//  ZKProofOfConcept
//
//  Created by Ronald "Danger" Mannak on 6/18/19.
//  Copyright © 2019 A Puzzle A Day. All rights reserved.
//

import Foundation

extension BlockData {
    
    var isValid: Bool {
        
        // 1. Confirm no used entries are stored
        for entry in self.balances {
            guard self.balances.filter({ $0.sha256 == entry.previousHash }).count == 0 else {
                return false
            }
        }
                
        // TODO: Finish
        
        // 2. Confirm that hash of every entry, contract, and metadata is in the leaves
        
        // 3. Check if merkle trees are valid
        
        return true
    }
    
}
