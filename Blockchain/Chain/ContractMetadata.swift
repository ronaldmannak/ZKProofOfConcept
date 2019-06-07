//
//  ContractMetadata.swift
//  ZKProofOfConcept
//
//  Created by Ronald "Danger" Mannak on 6/6/19.
//  Copyright © 2019 A Puzzle A Day. All rights reserved.
//

import Foundation

public struct ContractMetadata: Codable, Equatable {
    
}

extension ContractMetadata: Sha256Hashable {
    
    public var sha256: Sha256Hash {
        return try! JSONEncoder().encode(self).sha256
    }
}
