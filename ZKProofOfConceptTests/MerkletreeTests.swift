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
        
        XCTAssert(tree.hash.hexDescription == "fa13bb36c022a6943f37c638126a2c88fc8d008eb5a9fe8fcde17026807feae4")
        XCTAssert(tree.left!.hash.hexDescription == "5feceb66ffc86f38d952786c6d696c79c2dbc239dd4e91b46729d73a27fb57e9")
        XCTAssert(tree.right!.hash.hexDescription == "6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b")
        XCTAssert(tree.left!.left == nil)
        XCTAssert(tree.left!.right == nil)
        XCTAssert(tree.right!.left == nil)
        XCTAssert(tree.left!.right == nil)
    }

    func testEven() {
        
        /* Expected
         Root: 85df8945419d2b5038f7ac83ec1ec6b8267c40fdb3b1e56ff62f6676eb855e70
         
         Nodes: 33b675636da5dcc86ec847b38c08fa49ff1cace9749931e0a5d4dfdbdedd808a : 13656c83d841ea7de6ebf3a89e0038fea9526bd7f686f06f7a692343a8a32dca
         
         Leafs: 6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b : d4735e3a265e16eee03f59718b9b5d03019c07d8b6c51f90da3a666eec13ab35 : 4e07408562bedb8b60ce05c1decfe3ad16b72230967de01f640b7e4729b49fce : 4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a
         */
        
        let even = ["1", "2", "3", "4"]
        let hashes = even.map { $0.sha256 }
        let tree = Merkletree.create(with: hashes)
        
        XCTAssert(tree.hash.hexDescription == "85df8945419d2b5038f7ac83ec1ec6b8267c40fdb3b1e56ff62f6676eb855e70")

        XCTAssert(tree.left!.hash.hexDescription == "33b675636da5dcc86ec847b38c08fa49ff1cace9749931e0a5d4dfdbdedd808a")
        XCTAssert(tree.right!.hash.hexDescription == "13656c83d841ea7de6ebf3a89e0038fea9526bd7f686f06f7a692343a8a32dca")
        
        XCTAssert(tree.left!.left!.hash.hexDescription == "6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b")
        XCTAssert(tree.left!.right!.hash.hexDescription == "d4735e3a265e16eee03f59718b9b5d03019c07d8b6c51f90da3a666eec13ab35")
        XCTAssert(tree.right!.left!.hash.hexDescription == "4e07408562bedb8b60ce05c1decfe3ad16b72230967de01f640b7e4729b49fce")
        XCTAssert(tree.right!.right!.hash.hexDescription == "4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a")
        
        XCTAssertNil(tree.left!.left!.left)
        XCTAssertNil(tree.left!.left!.right)
        XCTAssertNil(tree.left!.right!.left)
        XCTAssertNil(tree.left!.right!.right)
        XCTAssertNil(tree.right!.left!.left)
        XCTAssertNil(tree.right!.left!.right)
        XCTAssertNil(tree.left!.right!.left)
        XCTAssertNil(tree.left!.right!.right)
    }
    
    func testOdd() {
        
        /* Expected
         Root: c19ce1b23fc9057eb072011d793ce33a47bb6fc3fe4cf9bf5d8f737abd3be0cb
         
         Nodes: 85df8945419d2b5038f7ac83ec1ec6b8267c40fdb3b1e56ff62f6676eb855e70 : d30fdaa341f427812d8c1a5d385a2183c5437890010879a4a0b3448488b50fb6
         
         Nodes: 33b675636da5dcc86ec847b38c08fa49ff1cace9749931e0a5d4dfdbdedd808a : 13656c83d841ea7de6ebf3a89e0038fea9526bd7f686f06f7a692343a8a32dca : 27e5b83f8aa4e302aea09b7a9c42babe2d50707cc32d24d17bc3d76cde14dfa5 :27e5b83f8aa4e302aea09b7a9c42babe2d50707cc32d24d17bc3d76cde14dfa5
         
         Leafs: 6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b : d4735e3a265e16eee03f59718b9b5d03019c07d8b6c51f90da3a666eec13ab35 : 4e07408562bedb8b60ce05c1decfe3ad16b72230967de01f640b7e4729b49fce : 4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a : ef2d127de37b942baad06145e54b0c619a1f22327b2ebbcfbec78f5564afe39d : ef2d127de37b942baad06145e54b0c619a1f22327b2ebbcfbec78f5564afe39d
         */
        
        let odd = ["1", "2", "3", "4", "5"]
        let hashes = odd.map { $0.sha256 }
        let tree = Merkletree.create(with: hashes)
        
        XCTAssert(tree.hash.hexDescription == "c19ce1b23fc9057eb072011d793ce33a47bb6fc3fe4cf9bf5d8f737abd3be0cb")
        
        XCTAssert(tree.left!.hash.hexDescription == "85df8945419d2b5038f7ac83ec1ec6b8267c40fdb3b1e56ff62f6676eb855e70")
        XCTAssert(tree.right!.hash.hexDescription == "d30fdaa341f427812d8c1a5d385a2183c5437890010879a4a0b3448488b50fb6")
        
        XCTAssert(tree.left!.left!.hash.hexDescription == "33b675636da5dcc86ec847b38c08fa49ff1cace9749931e0a5d4dfdbdedd808a")
        XCTAssert(tree.left!.right!.hash.hexDescription == "13656c83d841ea7de6ebf3a89e0038fea9526bd7f686f06f7a692343a8a32dca")
        XCTAssert(tree.right!.left!.hash.hexDescription == "27e5b83f8aa4e302aea09b7a9c42babe2d50707cc32d24d17bc3d76cde14dfa5")
        XCTAssert(tree.right!.right!.hash.hexDescription == "27e5b83f8aa4e302aea09b7a9c42babe2d50707cc32d24d17bc3d76cde14dfa5")
        
        XCTAssert(tree.left!.left!.left!.hash.hexDescription == "6b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b")
        XCTAssert(tree.left!.left!.right!.hash.hexDescription == "d4735e3a265e16eee03f59718b9b5d03019c07d8b6c51f90da3a666eec13ab35")
        XCTAssert(tree.left!.right!.left!.hash.hexDescription == "4e07408562bedb8b60ce05c1decfe3ad16b72230967de01f640b7e4729b49fce")
        XCTAssert(tree.left!.right!.right!.hash.hexDescription == "4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a")
        XCTAssert(tree.right!.left!.left!.hash.hexDescription == "ef2d127de37b942baad06145e54b0c619a1f22327b2ebbcfbec78f5564afe39d")
        XCTAssert(tree.right!.left!.right!.hash.hexDescription == "ef2d127de37b942baad06145e54b0c619a1f22327b2ebbcfbec78f5564afe39d")
        XCTAssert(tree.right!.right!.left!.hash.hexDescription == "ef2d127de37b942baad06145e54b0c619a1f22327b2ebbcfbec78f5564afe39d")
        XCTAssert(tree.right!.right!.right!.hash.hexDescription == "ef2d127de37b942baad06145e54b0c619a1f22327b2ebbcfbec78f5564afe39d")
    }

}
