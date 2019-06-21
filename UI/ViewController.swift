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
        
        NotificationCenter.default.addObserver(self, selector: #selector(setFields(_:)), name: .newBlock, object: nil)
        
        logView.string = ""
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @objc func setFields(_ notification: Notification) {
        (view.viewWithTag(1) as! NSTextField).stringValue = "Block height: \(blockController.block.roots.height)"
        
        logView.string = "test"
    }
}

