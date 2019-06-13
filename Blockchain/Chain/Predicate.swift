//
//  Predicate.swift
//  ZKProofOfConcept
//
//  Created by Ronald "Danger" Mannak on 5/29/19.
//  Copyright © 2019 A Puzzle A Day. All rights reserved.
//

import Foundation

public struct Predicate: Codable, Equatable {
    
    let arguments: [String]?
}

extension Predicate {
    init() {
        self.arguments = nil
    }
}

extension Predicate {
    
    public func run(block: Block, blockData: BlockData, result: (Bool) -> Void) {
        
        result(true)
    }
    
}
