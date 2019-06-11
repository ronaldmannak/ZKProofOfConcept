//
//  BlockTests.swift
//  ZKProofOfConceptTests
//
//  Created by Ronald "Danger" Mannak on 6/6/19.
//  Copyright © 2019 A Puzzle A Day. All rights reserved.
//

import XCTest
@testable import ZKProofOfConcept


class BlockTests: XCTestCase {

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
    
    func testGenesis() {
        
        XCTAssertNotNil(genesisBlock)
        
        let expectation = XCTestExpectation(description: "Genesis block is valid")
        genesisBlock.isValid {
            XCTAssertTrue($0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testCreateTransaction() {
        
    }
    
    func testValidBlock() {
//        XCTAssertNotNil(validBlock)
//        XCTAssertTrue(validBlock.isValid)
//        XCTAssertFalse(validBlock.isValidGenesis)
    }
    
    func testAlteredBlock() {
        
//        do {
//            let secondGenesisTest = try Block.createGenesis())
//            let secondGenesis = secondGenesisTest.0
//            let secondGenesisData = secondGenesisTest.1
//            
//            let invalidGenesis = Block(roots: <#T##Roots#>
//        } catch {
//            XCTFail("Unexpected error: \(error)")
//        }
        
        // Mining a block with an altered transaction should throw an
        // "EC signature verification failed, no match" error
//        XCTAssertThrowsError(try createAlteredBlock(from: key, previous: validBlock))
    }
    
}
