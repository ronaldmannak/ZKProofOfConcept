//
//  ViewController.swift
//  ZKProofOfConcept
//
//  Created by Ronald "Danger" Mannak on 5/27/19.
//  Copyright © 2019 A Puzzle A Day. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    var accounts: [Account]!
    var block: Block!
    var blockData: BlockData!

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            // Create genesis block
            let genesis = try Block.createGenesis()
            accounts = genesis.0
            block = genesis.1
            blockData = genesis.2
        } catch {
            NSAlert(error: error).runModal()
        }
        
        updateAccountInfo()
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func send(_ sender: NSButton) {
        
        let senderIndex = sender.tag / 10
        
        let toIndex = (view.viewWithTag(sender.tag - 1) as! NSPopUpButton).indexOfSelectedItem
        guard let amount = UInt64((view.viewWithTag(sender.tag - 2) as! NSTextField).stringValue) else {
            return
        }
        
        let sender = self.accounts[senderIndex]
        let recipient = Recipient(amount: amount, to: self.accounts[toIndex].address)
        sender.createTx(type: Data(), recipients: [recipient], block: self.block, blockData: self.blockData) { (tx, proof, error) in
            
            guard error == nil else {
                NSAlert(error: error!).runModal()
                return
            }
            print("Tx: \(tx!)")
            
            self.block.produce(currentBlockData: self.blockData, transactions: [tx!], proofs: [TransactionProof](), newEntries: tx!.message.outputs, newContracts: nil, newMetadata: nil, result: { block, blockData in
                
                self.block = block
                self.blockData = blockData
                self.updateAccountInfo()
            })
            
        }
        
//        print("from: \(senderIndex)")
//        print("to: \(toIndex)")
//        print("amount: \(amount)")
        
    }
    
    func updateAccountInfo() {
        
        for i in 0 ..< 8 {
            let balances = self.blockData.balances(for: self.accounts[i].address)
            
            (self.view.viewWithTag(i * 10) as! NSTextField).stringValue = "Account \(i+1): \(balances.0)"
        }
        
        self.view.window?.title = "\(self.block.roots.height)"
    }
    
}

