//
//  WalletViewController.swift
//  ZKProofOfConcept
//
//  Created by Ronald "Danger" Mannak on 6/20/19.
//  Copyright © 2019 A Puzzle A Day. All rights reserved.
//

import Cocoa

class WalletViewController: NSViewController {

    let blockController = BlockController.shared
    var account: Account! {
        didSet {
            self.setFields()
            NotificationCenter.default.addObserver(self, selector: #selector(newBlockReceived(_:)), name: .newBlock, object: nil)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .newBlock, object: nil)
    }
    
    override func viewDidAppear() {
        self.view.window?.title = account.name
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.view.window?.title = account.name
    }
    
    fileprivate func setFields() {
        
        (view.viewWithTag(100) as! NSTextField).stringValue = account.name
        (view.viewWithTag(102) as! NSTextField).stringValue = "\(self.blockController.blockData.balances(for: self.account.address).0) ZKC"
        (view.viewWithTag(103) as! NSTextField).stringValue = "Available: (Calculating)"
        (view.viewWithTag(104) as! NSTextField).stringValue = "Locked: (Calculating)"
    }
    
    @objc func newBlockReceived(_ notification: Notification) {
        self.setFields()
    }
    
    @IBAction func send(_ sender: Any) {
        
        let toIndex = (view.viewWithTag(2) as! NSPopUpButton).indexOfSelectedItem
        let to = self.blockController.accounts[toIndex]
        
        guard let amount = UInt64((view.viewWithTag(1) as! NSTextField).stringValue) else {
            return
        }
        
        blockController.send(from: self.account, to: to, amount: amount, type: Data())
        
/*
        let recipient = Recipient(amount: amount, to: self.blockController.accounts[toIndex].address)
        
        account.createTx(type: Data(), recipients: [recipient], block: self.blockController.block, blockData: self.blockController.blockData) { (tx, proof, error) in

            guard error == nil else {
                NSAlert(error: error!).runModal()
                return
            }
            print("Tx: \(tx!)")

            self.blockController.block.produce(currentBlockData: self.blockController.blockData, transactions: [tx!], proofs: [TransactionProof](), newContracts: nil, newMetadata: nil, result: { block, blockData, error in

                guard error == nil else {
                    NSAlert(error: error!).runModal()
                    return
                }

//                self.block = block
//                self.blockData = blockData
//                self.updateAccountInfo()
            })

        }*/

    }
    
    @IBAction func coinChange(_ sender: Any) {
    }
    
}
