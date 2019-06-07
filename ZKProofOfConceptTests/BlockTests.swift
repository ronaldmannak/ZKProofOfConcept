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

    var key: Key!
    var senderAddress: String!
    
    var genesis: Block!
    var genesisData: BlockData!
    var validBlock: Block!

    override func setUp() {
        
        super.setUp()
        
        do {
            key = try Key(with: UUID())
            senderAddress = try key.exportKey().hexDescription
            
            // Create genesis block
            let genesisBlockandData = try Block.createGenesis()
            genesis = genesisBlockandData.0
            genesisData = genesisBlockandData.1
            
            // Create valid block
//            validBlock = try createValidBlock(from: key, previous: genesis)
            
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    func testGenesis() {
        
        XCTAssertNotNil(genesis)
        
        let expectation = XCTestExpectation(description: "Genesis block is valid")
        genesis.isValid {
            XCTAssertTrue($0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
        
//        XCTAssertTrue(genesis.isValidGenesis)
    }
    
    func testValidBlock() {
        XCTAssertNotNil(validBlock)
//        XCTAssertTrue(validBlock.isValid)
//        XCTAssertFalse(validBlock.isValidGenesis)
    }
    
    func testAlteredBlock() {
        // Mining a block with an altered transaction should throw an
        // "EC signature verification failed, no match" error
//        XCTAssertThrowsError(try createAlteredBlock(from: key, previous: validBlock))
    }
    
}
