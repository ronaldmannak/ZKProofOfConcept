//
//  Merkletree.swift
//  ZKProofOfConceptTests
//
//  Created by Ronald "Danger" Mannak on 5/28/19.
//  Copyright © 2019 A Puzzle A Day. All rights reserved.
//

import XCTest
@testable import ZKProofOfConcept

class MerkletreeTests: XCTestCase {

    override func setUp() {
        
        
        
        
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testTiny() {
        
        /* Expected
         Root: fa13bb36c022a6943f37c638126a2c88fc8d008eb5a9fe8fcde17026807feae4
         
         Leafs: 5feceb66ffc86f38d952786c6d696c79c2dbc239dd4e91b46729d73a27fb57e9 : 6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b
         */
        
        let tiny = ["0", "1"]
        let hashes = tiny.map { $0.sha256 }
        let tree = Merkletree.create(with: hashes)
        
        print("----")
        print(hashes[0].hexDescription)
        print(hashes[1].hexDescription)
        
        print("======")
        print(tree.hash.hexDescription)
        print(tree.left!.hash.hexDescription)
        print(tree.right!.hash.hexDescription)
        
        
        XCTAssert(tree.hash.hexDescription == "fa13bb36c022a6943f37c638126a2c88fc8d008eb5a9fe8fcde17026807feae4")
        XCTAssert(tree.left!.hash.hexDescription == "5feceb66ffc86f38d952786c6d696c79c2dbc239dd4e91b46729d73a27fb57e9")
        XCTAssert(tree.right!.hash.hexDescription == "6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b")
        XCTAssert(tree.left!.left == nil)
        XCTAssert(tree.left!.right == nil)
        XCTAssert(tree.right!.left == nil)
        XCTAssert(tree.left!.right == nil)
    }
    
    func testOdd() {
        let odd = ["1", "2", "3", "4", "5"]
    }

    func testEven() {
        let even = ["1", "2", "3", "4"]
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
