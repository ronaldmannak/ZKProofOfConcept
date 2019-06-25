//
//  Predicate.swift
//  ZKProofOfConcept
//
//  Created by Ronald "Danger" Mannak on 5/29/19.
//  Copyright © 2019 A Puzzle A Day. All rights reserved.
//

import Foundation

public class Predicate: Codable {
    
    let contract: ContractAddress
    let arguments: [String]?
    
    // temp init
    init() {
        self.contract = Data()
        self.arguments = nil
    }
    
    init(contract: ContractAddress, arguments: [String]) {
        self.contract = contract
        self.arguments = arguments
    }
    
}


extension Predicate {
    
    public func run(block: Block, blockData: BlockData, result: (Bool, Error?) -> Void) {
        
        // search contract
        
        // copy files from block data into a temp directory
        
        // execute the
        
        result(true, nil)
        
//        let operation = ShellOperation.
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

extension Predicate: Equatable {
    
    public static func == (lhs: Predicate, rhs: Predicate) -> Bool {
        return lhs.contract == rhs.contract && lhs.arguments == rhs.arguments
    }
}
