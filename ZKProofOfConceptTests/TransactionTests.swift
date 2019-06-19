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
    
    func testCreateValidTransaction1() {
        
        let expectation = XCTestExpectation(description: "Create valid transaction 1")
        
        let recipient = Recipient(amount: 200, to: accounts[1].address)
        
        accounts[0].createTx(type: Data(), recipients: [recipient], block: genesisBlock, blockData: genesisData, replaceIfNeeded: false) { (tx, proof, error) in
            
            XCTAssertNotNil(tx)
            XCTAssertNil(proof)
            XCTAssertNil(error)
            
            let inputs = tx!.message.inputs
            let outputs = tx!.message.outputs
            print("*****")
            print(outputs)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    // Send money to yourself
    func testCreateValidTransaction2() {
        
        let expectation = XCTestExpectation(description: "Create valid transaction 2")
        
        let recipient = Recipient(amount: 100, to: accounts[0].address)
        
        accounts[0].createTx(type: Data(), recipients: [recipient], block: genesisBlock, blockData: genesisData, replaceIfNeeded: false) { (tx, proof, error) in
            
            XCTAssertNotNil(tx)
            XCTAssertNil(proof)
            XCTAssertNil(error)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }

    func testCreateInvalidTransaction1() {
        
        let expectation = XCTestExpectation(description: "Create invalid transaction 1")
        
        let recipient = Recipient(amount: 0, to: accounts[1].address)
        
        accounts[0].createTx(type: Data(), recipients: [recipient], block: genesisBlock, blockData: genesisData, replaceIfNeeded: false) { (tx, proof, error) in
            
            XCTAssertNil(tx)
            XCTAssertNil(proof)
            XCTAssertNotNil(error)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testCreateInvalidTransaction2() {
        
        let expectation = XCTestExpectation(description: "Create invalid transaction 2")
        
        let recipient = Recipient(amount: 1_000_000_000, to: accounts[0].address)
        
        accounts[0].createTx(type: Data(), recipients: [recipient], block: genesisBlock, blockData: genesisData, replaceIfNeeded: false) { (tx, proof, error) in
            
            XCTAssertNil(tx)
            XCTAssertNil(proof)
            XCTAssertNotNil(error)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    
    func testCreateMultipleTransactions() {
        
        let expectation = XCTestExpectation(description: "Create transaction")
        
        let recipient1 = Recipient(amount: 200, to: accounts[1].address)
        let recipient2 = Recipient(amount: 1000, to: accounts[2].address)
        
        accounts[0].createTx(type: Data(), recipients: [recipient1, recipient2], block: genesisBlock, blockData: genesisData, replaceIfNeeded: false) { (tx, proof, error) in
            
            XCTAssertNotNil(tx)
            XCTAssertNil(proof)
            XCTAssertNil(error)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testSendTransactions0() {
        
        let expectation = XCTestExpectation(description: "Send transactions 0")
        
        let sender = accounts[0]
        let recipient1 = Recipient(amount: 200, to: accounts[1].address)
        let recipient2 = Recipient(amount: 1000, to: accounts[2].address)
        
        sender.createTx(type: Data(), recipients: [recipient1, recipient2], block: genesisBlock, blockData: genesisData, replaceIfNeeded: false) { (tx, proof, error) in
            
            XCTAssertNotNil(tx)
            XCTAssertNil(proof)
            XCTAssertNil(error)
            
            self.genesisBlock.produce(currentBlockData: self.genesisData, transactions: [tx!], proofs: [TransactionProof](), newEntries: tx!.message.outputs, newContracts: nil, newMetadata: nil) { block, blockData in
                
                let expectedBalances: [uint64] = [15_000 - 200 - 1_000, 15_000 + 200, 15_000 + 1000, 15_000, 15_000, 15_000, 15_000, 15_000, 15_000, 15_000]
                XCTAssert(expectedBalances.count == 10)
                
                for i in 0 ..< 10 {
                    
                    let actualBalance = blockData.balances(for: self.accounts[i].address).0
                    XCTAssert(actualBalance == expectedBalances[i], "balance \(i): Found \(actualBalance), expected \(expectedBalances[i])")
                }
                
                let senderEntries = blockData.balances(for: sender.address).1
                XCTAssert(senderEntries?.count == 1)
                
                let recipient1Entries = blockData.balances(for: recipient1.to).1
                XCTAssert(recipient1Entries?.count == 2)

                let recipient2Entries = blockData.balances(for: recipient2.to).1
                XCTAssert(recipient2Entries?.count == 2)
                
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 2.0)
    }
    
    func testSendTransactions1() {
        
        let expectation = XCTestExpectation(description: "Send transactions 1")
        
        let sender1 = accounts[2]
        let recipients = [
            Recipient(amount: 1200, to: accounts[9].address),
            Recipient(amount: 1000, to: accounts[1].address),
            Recipient(amount: 54, to: accounts[8].address),
        ]
        
        sender1.createTx(type: Data(), recipients: recipients, block: genesisBlock, blockData: genesisData, replaceIfNeeded: false) { (tx, proof, error) in
            
            XCTAssertNotNil(tx)
            XCTAssertNil(proof)
            XCTAssertNil(error)
            
            self.genesisBlock.produce(currentBlockData: self.genesisData, transactions: [tx!], proofs: [TransactionProof](), newEntries: tx!.message.outputs, newContracts: nil, newMetadata: nil) { block, blockData in
                
                let expectedBalances: [uint64] = [15_000, 15_000 + 1_000, 15_000 - 1_000 - 1_200 - 54, 15_000, 15_000, 15_000, 15_000, 15_000, 15_000 + 54, 15_000 + 1_200 ]
                XCTAssert(expectedBalances.count == 10)
                
                for i in 0 ..< 10 {
                    
                    let actualBalance = blockData.balances(for: self.accounts[i].address).0
                    XCTAssert(actualBalance == expectedBalances[i], "balance \(i): Found \(actualBalance), expected \(expectedBalances[i])")
                }
                
                let newRecipients = [
                    Recipient(amount: 7_000, to: self.accounts[7].address),
                    Recipient(amount: 5_000, to: self.accounts[1].address),
                    Recipient(amount: 864, to: self.accounts[8].address),
                ]
                
                let sender2 = self.accounts[9]
                sender2.createTx(type: Data(), recipients: newRecipients, block: block, blockData: blockData, replaceIfNeeded: false) { (tx, proof, error) in
                    
                    XCTAssertNotNil(tx)
                    XCTAssertNil(proof)
                    XCTAssertNil(error)
                    
                    self.genesisBlock.produce(currentBlockData: blockData, transactions: [tx!], proofs: [TransactionProof](), newEntries: tx!.message.outputs, newContracts: nil, newMetadata: nil) { block, blockData in
                        
                        let expectedBalances: [uint64] = [15_000, 16_000 + 5_000, 12_746, 15_000, 15_000, 15_000, 15_000, 15_000 + 7_000, 15_054 + 864, 16_200 - 7_000 - 5_000 - 864]
                        XCTAssert(expectedBalances.count == 10)
                        
                        for i in 0 ..< 10 {
                            
                            let actualBalance = blockData.balances(for: self.accounts[i].address).0
                            XCTAssert(actualBalance == expectedBalances[i], "balance \(i): Found \(actualBalance), expected \(expectedBalances[i])")
                        }
                        
                        let sender1Entries = blockData.balances(for: sender1.address).1
                        XCTAssert(sender1Entries?.count == 1)

                        let sender2Entries = blockData.balances(for: sender2.address).1
                        XCTAssert(sender2Entries?.count == 2, "found \(sender2Entries!.count) entries")

                        
//                        let recipient1Entries = blockData.balances(for: recipient1.to).1
//                        XCTAssert(recipient1Entries?.count == 2)
//
//                        let recipient2Entries = blockData.balances(for: recipient2.to).1
//                        XCTAssert(recipient2Entries?.count == 2
                
                        expectation.fulfill()
                    }
                }
            }
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testReplay() {
        
        let expectation = XCTestExpectation(description: "replay")
        
        let recipients = [
            Recipient(amount: 1200, to: accounts[9].address),
            Recipient(amount: 1000, to: accounts[1].address),
            Recipient(amount: 54, to: accounts[8].address),
            ]
        
        accounts[2].createTx(type: Data(), recipients: recipients, block: genesisBlock, blockData: genesisData, replaceIfNeeded: false) { (tx, proof, error) in
            
            XCTAssertNotNil(tx)
            XCTAssertNil(proof)
            XCTAssertNil(error)
            
            self.genesisBlock.produce(currentBlockData: self.genesisData, transactions: [tx!], proofs: [TransactionProof](), newEntries: tx!.message.outputs, newContracts: nil, newMetadata: nil) { block, blockData in
                
                let expectedBalances: [uint64] = [15_000, 15_000 + 1_000, 15_000 - 1_000 - 1_200 - 54, 15_000, 15_000, 15_000, 15_000, 15_000, 15_000 + 54, 15_000 + 1_200 ]
                XCTAssert(expectedBalances.count == 10)
                
                for i in 0 ..< 10 {
                    
                    let actualBalance = blockData.balances(for: self.accounts[i].address).0
                    XCTAssert(actualBalance == expectedBalances[i], "balance \(i): Found \(actualBalance), expected \(expectedBalances[i])")
                }
                
                self.genesisBlock.produce(currentBlockData: blockData, transactions: [tx!], proofs: [TransactionProof](), newEntries: tx!.message.outputs, newContracts: nil, newMetadata: nil) { block, blockData in
                    
                    // Balances should be the same as before
                    let expectedBalances: [uint64] = [15_000, 15_000 + 1_000, 15_000 - 1_000 - 1_200 - 54, 15_000, 15_000, 15_000, 15_000, 15_000, 15_000 + 54, 15_000 + 1_200 ]
                    XCTAssert(expectedBalances.count == 10)
                    XCTAssert(expectedBalances.count == 10)
                    
                    for i in 0 ..< 10 {
                        
                        let actualBalance = blockData.balances(for: self.accounts[i].address).0
                        XCTAssert(actualBalance == expectedBalances[i], "balance \(i): Found \(actualBalance), expected \(expectedBalances[i])")
                    }
                    
                    expectation.fulfill()
                }
            }
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testOutputs() {
     
        let expectation = XCTestExpectation(description: "replay")
        
        let recipients = [
            Recipient(amount: 1200, to: accounts[9].address),
            Recipient(amount: 1000, to: accounts[1].address),
            Recipient(amount: 54, to: accounts[8].address),
            ]
        
        let sender = accounts[2]
        sender.createTx(type: Data(), recipients: recipients, block: genesisBlock, blockData: genesisData, replaceIfNeeded: false) { (tx, proof, error) in
            
            XCTAssertNotNil(tx)
            XCTAssertNil(proof)
            XCTAssertNil(error)
        
            // Sanity check input
            let inputs = tx!.message.inputs
            XCTAssert(inputs.count == 1)
            let input = inputs[0]
            XCTAssert(input.balance == 15_000)
            XCTAssert(input.owner == sender.address)
            
            let outputs = tx!.message.outputs
            XCTAssert(outputs.count == 4)
            
            // Validate inputs from sender
            let senderOutputs = tx!.message.outputs.filter { $0.owner == sender.address }
            XCTAssert(senderOutputs.count == 1)
            XCTAssert(senderOutputs[0].balance == 15_000 - 1_200 - 1_000 - 54)
            
            // Validate account 9
            let account9Outputs = tx!.message.outputs.filter { $0.owner == self.accounts[9].address }
            XCTAssert(account9Outputs.count == 1)
            XCTAssert(account9Outputs[0].balance == 1_200)
            
            // Validate account 1
            let account1Outputs = tx!.message.outputs.filter { $0.owner == self.accounts[1].address }
            XCTAssert(account1Outputs.count == 1)
            XCTAssert(account1Outputs[0].balance == 1_000)
            
            // Validate account 8
            let account8Outputs = tx!.message.outputs.filter { $0.owner == self.accounts[8].address }
            XCTAssert(account8Outputs.count == 1)
            XCTAssert(account8Outputs[0].balance == 54)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testConsolidateOutputs() {
        
    }
    
    // Pass blockdata that is not the correct data for block
    func testDetachedBlockData() {
        
    }
}
