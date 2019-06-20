//
//  Block+Producer.swift
//  ZKProofOfConcept
//
//  Created by Ronald "Danger" Mannak on 6/14/19.
//  Copyright © 2019 A Puzzle A Day. All rights reserved.
//

import Foundation

extension Block {
    
    public func produce(currentBlockData: BlockData, transactions: [Transaction]?, proofs: [TransactionProof]?, newContracts: [Contract]?, newMetadata: [ContractMetadata]?, result: (Block?, BlockData?, Error?) -> Void) {
        
        // 1. Validate blockdata hashes
        guard self.quickValidate(blockData: currentBlockData) == true else {
            result (nil, nil, ZKError.invalidBlockData)
            return
        }
        
        // 2. Filter out invalid transactions
        var newEntries = [Entry]()
        if let transactions = transactions {
            let validTransactions = transactions.filter{ $0.isSignatureValid }
            newEntries = validTransactions.flatMap{ $0.message.outputs }
        }
        
        // 3. Remove spent entries
        var filteredEntries = currentBlockData.balances
        for entry in newEntries {
            filteredEntries = filteredEntries.filter{ $0.sha256 != entry.previousHash }
        }
        
        // 4. Add new entries
        filteredEntries.append(contentsOf: newEntries)
        
        // 5. Create new block data
        let newBlockData = BlockData(balances: filteredEntries, contracts: currentBlockData.contracts, metadata: currentBlockData.metadata, transactions: proofs ?? [TransactionProof]())
        
        guard newBlockData.isValid == true else {
            
            result(nil, nil, ZKError.invalidBlock)
            return
        }
        
        let roots = Roots(previous: self, balancesRoot: newBlockData.balancesTree.hash, contractsRoot: newBlockData.contractsTree.hash, metadataRoot: newBlockData.metadataTree.hash, transactionsRoot: newBlockData.transactionsTree?.hash)
        
        let newBlock = Block(roots: roots)
        
        guard newBlock.quickValidate(blockData: newBlockData) else {
            
            result(nil, nil, ZKError.invalidBlock)
            return
        }
        
        result(newBlock, newBlockData, nil)
    }
}
