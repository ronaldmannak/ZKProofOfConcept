//
//  Entry+Predicate.swift
//  ZKProofOfConcept
//
//  Created by Ronald "Danger" Mannak on 6/25/19.
//  Copyright © 2019 A Puzzle A Day. All rights reserved.
//

import Foundation

extension Entry {
    
    public func isSpendable(block: Block, blockData: BlockData, result: (Bool, Error?) -> Void) {
        
        // If no predicate is set, entry can be spend
        guard let predicate = self.spendPredicate else {
            result(true, nil)
            return
        }
        
        predicate.run(block: block, blockData: blockData) { result($0, $1) }
    }
    
    public func add(predicate: Predicate) {
        
    }
}
