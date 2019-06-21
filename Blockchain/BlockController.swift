//
//  BlockController.swift
//  ZKProofOfConcept
//
//  Created by Ronald "Danger" Mannak on 6/20/19.
//  Copyright © 2019 A Puzzle A Day. All rights reserved.
//

import Foundation
import Cocoa

public final class BlockController {
    
    static let shared = BlockController()
    
    var accounts: [Account]!
    fileprivate (set) var block: Block!
    fileprivate (set) var blockData: BlockData!
    
    private init() {
        
            do {
                // Create genesis block
                let genesis = try Block.createGenesis()
                accounts = genesis.0
                block = genesis.1
                blockData = genesis.2
            } catch {
                NSAlert(error: error).runModal()
            }
    }
    
    public func send(from: Account, to: Account, amount: UInt64, type: ContractAddress) {
        
        
        
        
        let recipient = Recipient(amount: amount, to: to.address)
        
        from.createTx(type: Data(), recipients: [recipient], block: self.block, blockData: self.blockData) { (tx, proof, error) in
            
            guard error == nil else {
                NSAlert(error: error!).runModal()
                return
            }
            print("Tx: \(tx!)")
            
            self.block.produce(currentBlockData: self.blockData, transactions: [tx!], proofs: [TransactionProof](), newContracts: nil, newMetadata: nil, result: { block, blockData, error in
                
                guard error == nil else {
                    NSAlert(error: error!).runModal()
                    return
                }
                
                self.block = block
                self.blockData = blockData
                NotificationCenter.default.post(name: .newBlock, object: nil, userInfo: nil)
            })
            
        }
    }
    
}
