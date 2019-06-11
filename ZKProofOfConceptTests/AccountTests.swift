//
//  AccountTests.swift
//  ZKProofOfConceptTests
//
//  Created by Ronald "Danger" Mannak on 6/11/19.
//  Copyright © 2019 A Puzzle A Day. All rights reserved.
//

import XCTest
@testable import ZKProofOfConcept

class AccountTests: XCTestCase {

    
    var account1: Account!
    var account2: Account!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        do {
            account1 = try Account(named: "Account1")
            account2 = try Account(named: "Account2")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testInitialization() {
        XCTAssert(account1.name == "Account1")
        XCTAssert(account2.name == "Account2")
    }
    
    func testSignatures() {
        
        let data1 = "Message".data(using: .utf8)!
        let data2 = "Invalid".data(using: .utf8)!
    
        let signature = account1.sign(data1)!
        
        XCTAssertTrue(account1.verify(signature: signature, digest: data1))
        XCTAssertFalse(account1.verify(signature: signature, digest: data2))
        XCTAssertFalse(account2.verify(signature: signature, digest: data1))
        XCTAssertFalse(account2.verify(signature: signature, digest: data2))
    }
    
    func testEncryption() {
        
        let data1 = "Message".data(using: .utf8)!
        let data2 = "Invalid".data(using: .utf8)!

        let cipherText = account1.encrypt(data1)!
        
        XCTAssertTrue(account1.decrypt(cipherText)! == data1)
        XCTAssertNil(account1.decrypt(data2))
        XCTAssertNil(account2.decrypt(cipherText))
        XCTAssertNil(account2.decrypt(cipherText))
    }


//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
