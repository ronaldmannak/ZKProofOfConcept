//
//  Block.swift
//  ZKProofOfConcept
//
//  Created by Ronald "Danger" Mannak on 5/27/19.
//  Copyright © 2019 A Puzzle A Day. All rights reserved.
//

import Foundation

public struct Roots: Codable, Equatable, Sha256Hashable {
    
    // Hash of the previous block. Nil if this block is the genesis block
    public let previousBlockHash: Sha256Hash?
    
    /// Block height
    public let height: UInt64
    
    /// Timestamp of creation
    public let timestamp: TimeInterval
    
    // Merkle roots
    public let balancesRoot: Sha256Hash
    
    public let contractsRoot: Sha256Hash
    
    public let metadataRoot: Sha256Hash
    
    public let transactionsRoot: Sha256Hash
    
    /// Stored zero knowledge proof
    public let proof: ZKProof
    
    /// Computed property of the block hash
    public var sha256: Sha256Hash {
        return try! JSONEncoder().encode(self).sha256
    }
    
    init(previous: Block?, balances: Merkletree, contracts: Merkletree, transactions: Merkletree, metadata: Merkletree) {
        
        self.previousBlockHash = previous?.sha256
        self.height = (previous?.roots.height == nil ? 0 : previous!.roots.height + 1)
        self.timestamp = Date.timeIntervalSinceReferenceDate
        self.balancesRoot = balances.hash
        self.contractsRoot = contracts.hash
        self.metadataRoot = metadata.hash
        self.transactionsRoot = transactions.hash
        self.proof = ZKProof(a: ["test"], b: ["test"], c: ["test"], inputs: ["test"]) // temp
    }
}

public struct Block: Codable, Equatable, Sha256Hashable {
    
    public let roots: Roots
    
    /// Stored hashValue of the roots property. Should always be equal to computed property message.hashValue
    /// If the hashses are different, the roots have been altered and the block should be invalidated
    public let sha256: Sha256Hash
    
    init(roots: Roots) {
        self.roots = roots
        sha256 = roots.sha256
    }
}

extension Block {
    
    public static func createBlock(previous: Block? = nil, balances: Merkletree, contracts: Merkletree, metadata: Merkletree, result: (Block, BlockData) -> Void) {
        
    }
    
}
