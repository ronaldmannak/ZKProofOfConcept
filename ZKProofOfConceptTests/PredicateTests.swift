//
//  PredicateTests.swift
//  ZKProofOfConceptTests
//
//  Created by Ronald "Danger" Mannak on 6/24/19.
//  Copyright © 2019 A Puzzle A Day. All rights reserved.
//

import XCTest
@testable import ZKProofOfConcept

class PredicateTests: XCTestCase {

    var accounts: [Account]!
    var block: Block!
    var data: BlockData!
    
    override func setUp() {
        
        super.setUp()
        
        do {
            // Create genesis block
            let genesis = try Block.createGenesis()
            self.accounts = genesis.0
            self.block = genesis.1
            self.data = genesis.2
            
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    override func tearDown() {
        
        super.tearDown()
    }
    
    func testSanity() {
        
        XCTAssertNotNil(self.accounts)
        XCTAssertNotNil(self.data)
        XCTAssertNotNil(self.block)
        XCTAssert(accounts.count == 10)
    }

    func testSimplePredicate() {
        
        guard let entries = self.data.entries(for: accounts[0].address) else {
            XCTFail()
            return
        }
        XCTAssert(entries.count == 1)

        let expectation = XCTestExpectation(description: "simple predicate")
        entries[0].isSpendable(block: self.block, blockData: self.data) { result, error in
            
            XCTAssertNil(error)
            XCTAssertTrue(result)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
}
