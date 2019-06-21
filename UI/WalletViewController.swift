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
        
    }
    
    @IBAction func coinChange(_ sender: Any) {
    }
    
}
