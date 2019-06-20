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
    
}
