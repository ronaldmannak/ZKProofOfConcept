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
    
    func testSanity() {
        
        XCTAssertNotNil(accounts)
        XCTAssertNotNil(genesisData)
        XCTAssertNotNil(genesisBlock)
        XCTAssert(accounts.count == 10)
    }
    
    func testCreateTransaction() {
        
        let expectation = XCTestExpectation(description: "Create transaction")
        
        let recipient = Recipient(amount: 200, to: accounts[1].address)
        
        accounts[0].createTx(type: Data(), recipients: [recipient], block: genesisBlock, blockData: genesisData, replaceIfNeeded: false) { (tx, proof, error) in
            
            XCTAssertNotNil(tx)
            XCTAssertNil(proof)
            XCTAssertNil(error)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    /*
    func testCreateMultipleTransactions() {
        
        let expectation = XCTestExpectation(description: "Create transaction")
        
        let recipient1 = Recipient(amount: 200, to: accounts[1].address)
        let recipient2 = Recipient(amount: 1000, to: accounts[2].address)
        
        accounts[0].createTx(type: Data(), recipients: [recipient1, recipient2], block: genesisBlock, blockData: genesisData, replaceIfNeeded: false) { (tx, proof, error) in
            
            XCTAssertNotNil(tx)
            XCTAssertNotNil(proof)
            XCTAssertNil(error)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }*/
    
}
