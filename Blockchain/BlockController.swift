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
    
    
}
