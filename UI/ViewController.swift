//
//  ViewController.swift
//  ZKProofOfConcept
//
//  Created by Ronald "Danger" Mannak on 5/27/19.
//  Copyright © 2019 A Puzzle A Day. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet var logView: NSTextView!
    
    let blockController = BlockController.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(newBlockReceived(_:)), name: .newBlock, object: nil)
        
        for account in blockController.accounts.enumerated() {
            logView.string += "account\(account.offset): \(account.element.address.hexDescription.suffix(4))\n"
        }
        setFields()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @objc func newBlockReceived(_ notification: Notification) {
        
        setFields()
    }
    
    func setFields() {
        
        (view.viewWithTag(1) as! NSTextField).stringValue = "Block height: \(blockController.block.roots.height)"
        
        logView.string += "\n"
        
        let orderedEntries = blockController.blockData.balances.sorted { $0.owner.description > $1.owner.description }
        
        for entry in orderedEntries.enumerated() {
            logView.string += "\(entry.offset): " + entry.element.description
        }
    }
}

