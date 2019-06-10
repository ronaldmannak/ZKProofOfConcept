//
//  Block+Validation.swift
//  ZKProofOfConcept
//
//  Created by Ronald "Danger" Mannak on 6/6/19.
//  Copyright © 2019 A Puzzle A Day. All rights reserved.
//

import Foundation

extension Block {
    
    public func isValid(result: (Bool) -> Void) {
        
        guard self.sha256 == self.roots.sha256 else {
            result(false)
            return
        }
        
        // TODO: validate proof
        
        result(true)
    }
    
    public func validateBlockData(_ blockData: BlockData, result: (Bool) -> Void) {
        
        self.isValid { validHashAndProof in
            
            // 1. Validate self and blockData
            guard validHashAndProof == true && blockData.isValid == true else {
                
                result(false)
                return
            }
            
            // 2. Check if blockData is part of the block
            guard self.roots.balancesRoot == blockData.balancesTree.hash &&
                self.roots.contractsRoot == blockData.contractsTree.hash &&
                self.roots.metadataRoot == blockData.metadataTree.hash &&
                self.roots.transactionsRoot == blockData.transactionsTree?.hash
                else {
                    
                    result(false)
                    return
            }
            
            result(true)
        }
    }
}
