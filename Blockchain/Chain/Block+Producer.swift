//
//  Block+Producer.swift
//  ZKProofOfConcept
//
//  Created by Ronald "Danger" Mannak on 6/14/19.
//  Copyright © 2019 A Puzzle A Day. All rights reserved.
//

import Foundation

extension Block {
    
    public func produce(currentBlockData: BlockData, transactions: [Transaction]?, proofs: [TransactionProof]?, newEntries: [Entry]?, newContracts: [Contract]?, newMetadata: [ContractMetadata]?, result: (Block, BlockData) -> Void) {
        
        // 1. Validate blockdata hashes
        
        // 2. Remove spent entries
        var filteredEntries = currentBlockData.balances
        if let newEntries = newEntries {
            for entry in newEntries {
                filteredEntries = filteredEntries.filter{ $0.sha256 != entry.previousHash }
            }
        }
        
        // 3. Add new entries
        if let newEntries = newEntries {
            filteredEntries.append(contentsOf: newEntries)
        }
        
        // 4. Create new block data
        let newBlockData = BlockData(balances: filteredEntries, contracts: currentBlockData.contracts, metadata: currentBlockData.metadata, transactions: proofs ?? [TransactionProof]())
        
        let roots = Roots(previous: self, balancesRoot: newBlockData.balancesTree.hash, contractsRoot: newBlockData.contractsTree.hash, metadataRoot: newBlockData.metadataTree.hash, transactionsRoot: newBlockData.transactionsTree?.hash)
        
        let newBlock = Block(roots: roots)
        
        result(newBlock, newBlockData)
    }
}
