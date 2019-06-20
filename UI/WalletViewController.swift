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
    var account: Account!
    
    override func viewDidAppear() {
        self.view.window?.title = account.name
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.view.window?.title = account.name
    }
    
    @IBAction func send(_ sender: Any) {
        
        let toIndex = (view.viewWithTag(2) as! NSPopUpButton).indexOfSelectedItem
        guard let amount = UInt64((view.viewWithTag(1) as! NSTextField).stringValue) else {
            return
        }

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

        }

    }
    
    @IBAction func coinChange(_ sender: Any) {
    }
    
}
