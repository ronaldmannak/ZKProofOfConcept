//
//  AppDelegate.swift
//  ZKProofOfConcept
//
//  Created by Ronald "Danger" Mannak on 5/27/19.
//  Copyright © 2019 A Puzzle A Day. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    fileprivate (set) var walletWindows = [NSWindowController]()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        let storyboard = NSStoryboard(name: "Wallet", bundle: nil)
        
        for i in 0 ..< 10 {
            
            let controller = storyboard.instantiateInitialController() as! NSWindowController
            walletWindows.append(controller)
            controller.shouldCascadeWindows = true
            
            let vc = controller.contentViewController as! WalletViewController
            vc.account = BlockController.shared.accounts[i]

//            // Set account
//
            if i < 3 {
                controller.showWindow(self)
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func showWallet(_ sender: Any) {
        
        print (sender)
        guard let sender = sender as? NSMenuItem else { return }
        let controller = walletWindows[sender.tag]
        controller.showWindow(self)
    }
    
//    func viewControllerFor(account: Account) -> WalletViewController {
    
//        let index = BlockController.shared.accounts.index(of: account)
        
        
//    }

}

