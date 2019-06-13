//
//  TransactionTests.swift
//  ZKProofOfConceptTests
//
//  Created by Ronald "Danger" Mannak on 6/6/19.
//  Copyright © 2019 A Puzzle A Day. All rights reserved.
//

import XCTest
@testable import ZKProofOfConcept


class TransactionTests: XCTestCase {

    var accounts: [Account]!
    var genesisBlock: Block!
    var genesisData: BlockData!
    var validBlock: Block!
    
    override func setUp() {
        
        super.setUp()
        
        do {
            // Create genesis block
            let genesis = try Block.createGenesis()
            accounts = genesis.0
            genesisBlock = genesis.1
            genesisData = genesis.2
            
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    func testcreateTransaction() {
        
        let transaction = Transaction(sender: <#T##AccountAddress#>, type: <#T##ContractAddress#>, recipients: <#T##[Recipient]#>, block: <#T##Block#>, blockData: <#T##BlockData#>, sign: <#T##(Digest) throws -> Signature#>)
        
//        let transaction = Transaction(sender: accounts[0], amount: 100, type: Data(), recipients: accounts[1], block: genesisBlock, blockData: genesisData) { (<#Digest#>) -> Signature in
//            <#code#>
//        }
        // send Account instead of AccountAddress?
        // why have bock sign the code?
        
    }
    
}
