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
    
    public let contractsRoot: Sha256Hash?
    
    public let metadataRoot: Sha256Hash?
    
    public let transactionsRoot: Sha256Hash?
    
    /// Stored zero knowledge proof
    public let proof: ZKProof
    
    /// Computed property of the block hash
    public var sha256: Sha256Hash {
        return try! JSONEncoder().encode(self).sha256
    }
    
    init(previous: Block?, balancesRoot: Sha256Hash, contractsRoot: Sha256Hash, transactionsRoot: Sha256Hash, metadataRoot: Sha256Hash) {
        
        self.previousBlockHash = previous?.sha256
        self.height = previous?.roots.height == nil ? 0 : previous!.roots.height + 1
        self.timestamp = Date.timeIntervalSinceReferenceDate
        self.balancesRoot = balancesRoot
        self.contractsRoot = contractsRoot
        self.metadataRoot = metadataRoot
        self.transactionsRoot = transactionsRoot
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
    
//    public static func mine(previous: Block, ) {
//        
//        
//    }
    
    /// Create genesis block
    /// Creates 10 accounts with each 15,000 tokens
    public static func createGenesis(amount: Amount = 15_000) throws -> (Block, BlockData){
        
        // 1. Create 10 accounts and set initial amounts
        var accounts = [Account]()
        var balances = [Entry]()
        for i in 0 ..< 10 {
            
            let account = try Account(named: "Account\(i)")
            accounts.append(account)
            
            let entry = Entry(owner: account.address, balance: amount, entryType: .fungible, type: Data(), spendPredicate: Predicate(), spendPredicateArguments: nil, data: nil)
            balances.append(entry)
        }
        
        // 2. Create roots
        let roots = Roots(previous: nil, balancesRoot: balances.sha256, contractsRoot: Data(), transactionsRoot: Data(), metadataRoot: Data())
        
        // 3. init block
        let block = Block(roots: roots)
        
        // 4. init block data
        let blockData = BlockData(balancesTree: Merkletree.create(with: balances.map { $0.sha256 }),
                                  balances: balances,
                                  contractsTree: Merkletree.create(with: [Data().sha256]),
                                  contracts: [Contract](),
                                  metadataTree: Merkletree.create(with: [Data().sha256]),
                                  metadata: [ContractMetadata](),
                                  transactionsTree: Merkletree.create(with: [Data().sha256]),
                                  transactions: [TransactionProof]())
        
        return (block, blockData)
    }
}

extension Block {
    
    public static func createBlock(previous: Block? = nil, balances: Merkletree, contracts: Merkletree, metadata: Merkletree, result: (Block, BlockData) -> Void) {
        
    }
    
}
