//
//  BlockData.swift
//  ZKProofOfConcept
//
//  Created by Ronald "Danger" Mannak on 6/5/19.
//  Copyright © 2019 A Puzzle A Day. All rights reserved.
//

import Foundation

public struct BlockData: Codable, Equatable {
    
    public let balancesTree: Merkletree
    
    public let balances: [Entry]

    public let contractsTree: Merkletree

    public let contracts: [Contract]

    public let metadataTree: Merkletree

    public let metadata: [ContractMetadata]

    public let transactionsTree: Merkletree?

    public let transactions: [TransactionProof]?
    
    public var isValid: Bool {
        
        // 1. Confirm that hash of every entry, contract, and metadata is in the leaves
        
        // 2. Check if merkle trees are valid
        
        return false
    }
}

extension BlockData {
    
    public init(balances: [Entry], contracts: [Contract], metadata: [ContractMetadata], transactions: [TransactionProof]) {
        
        self.balances = balances
        self.balancesTree = Merkletree.create(with: balances.map{ $0.sha256 })
        
        self.contracts = contracts
        self.contractsTree = Merkletree.create(with: contracts.map{ $0.sha256 })
        
        self.metadata = metadata
        self.metadataTree = Merkletree.create(with: metadata.map{ $0.sha256 })
        
        self.transactions = transactions
        self.transactionsTree = Merkletree.create(with: transactions.map{ $0.transaction.sha256 })        
    }
}

extension BlockData: Sha256Hashable {
    
    public var sha256: Sha256Hash {
        return try! JSONEncoder().encode(self).sha256
    }

}
