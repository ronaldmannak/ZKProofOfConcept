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
        
        // 1. Confirm no entries are double spend
//        for entry in self.balances {
//            guard self.balances.filter({ $0.sha256 == entry.previousHash }).count == 0 else {
//                return false
//            }
//        }
//
//        // 2. Confirm no new coins are created
//        for entry in self.balances {
//
//            // 2a. Gather all entries that refer to the same output
//            let spent = self.balances.filter({ $0.previousHash != nil && $0.previousHash == entry.previousHash }).reduce(UInt64(0), { $0 + $1.balance })
//
//            // 2b. There can only be a single output
//            let output = self.balances.filter({ $0.sha256 == $0.previousHash })
//            guard output.count == 1 else {
//                return false
//            }
//
//            guard spent <= output[0].balance else {
//                return false
//            }
        
            
//            let multiple self.balances.filter({ $0.sha256 != entry.sha256 }).filter({ $0.previousHash != nil }).filter({ $0.previousHash == entry.previousHash })
//            guard .count == 0 else {
//
//
//
//
//                let entries = self.balances.filter({ $0.previousHash == entry.previousHash })
//                print(entries)
//
//                return false
//            }
//        }
        
        // TODO: Finish
        
        // 2. Confirm that hash of every entry, contract, and metadata is in the leaves
        
        // 3. Check if merkle trees are valid
        
        return true
    }
    
}
