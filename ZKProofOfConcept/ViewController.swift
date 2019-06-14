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
    var genesisBlock: Block!
    var genesisData: BlockData!

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            // Create genesis block
            let genesis = try Block.createGenesis()
            accounts = genesis.0
            genesisBlock = genesis.1
            genesisData = genesis.2
        } catch {
            NSAlert(error: error).runModal()
        }
        
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
        
        guard senderIndex != toIndex else { return }
        
        let sender = self.accounts[senderIndex]
        let recipient = Recipient(amount: amount, to: self.accounts[toIndex].address)
        sender.createTx(type: Data(), recipients: [recipient], block: self.genesisBlock, blockData: self.genesisData) { (tx, proof, error) in
            
            guard error == nil else {
                NSAlert(error: error!).runModal()
                return
            }
            print("Tx: \(tx!)")
            
            
        }
        
        print("from: \(senderIndex)")
        print("to: \(toIndex)")
        print("amount: \(amount)")
        
    }
    
}

