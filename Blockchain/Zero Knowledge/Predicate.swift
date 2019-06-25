//
//  Predicate.swift
//  ZKProofOfConcept
//
//  Created by Ronald "Danger" Mannak on 6/24/19.
//  Copyright © 2019 A Puzzle A Day. All rights reserved.
//

import Foundation

public final class Predicate {//Codable, Equatable {
    
    let block: Block
    let blockData: BlockData
    let address: ContractAddress
    let arguments: [String]?
    
    init(block: Block, blockData: BlockData, address: ContractAddress, arguments: [String]? = nil) {
        self.block = block
        self.blockData = blockData
        self.address = address
        self.arguments = arguments
    }
 
    public func run(result: (Bool) -> Void) {
        
        result(true)
    }
}

extension Predicate: ShellProtocol {
    func shell(_ shell: ShellOperation, didReceiveStdout string: String) {
        print("stdOut: \(string)")
    }
    
    func shell(_ shell: ShellOperation, didReceiveStderr string: String) {
        print("stdErr: \(string)")
    }
    
    func shell(_ shell: ShellOperation, didReceiveStdin string: String) {
        print("stdIn: \(string)")
    }
    
}
