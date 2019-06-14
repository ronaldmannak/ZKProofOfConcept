//
//  Merkletree.swift
//  ZKProofOfConcept
//
//  Created by Ronald "Danger" Mannak on 5/28/19.
//  Copyright © 2019 A Puzzle A Day. All rights reserved.
//

import Foundation

public final class Merkletree: Codable {
    
    let hash: Sha256Hash
    let left: Merkletree?
    let right: Merkletree?
    
    public init(hash: Hash, left: Merkletree?, right: Merkletree?) {
        self.hash = hash
        self.left = left
        self.right = right
    }
    
    public static func create(with hashes: [Hash]) -> Merkletree {
        
        guard hashes.count > 0 else {
            return Merkletree(hash: Data().sha256, left: nil, right: nil)
        }
        
        // Make sure we have an even number of hashes
        let hashes = prepare(hashes) as! [Hash]
        
        var nodeArray = hashes.map { Merkletree(hash: $0, left: nil, right: nil) }
                
        while nodeArray.count > 1 {
            
            var internalNodes = [Merkletree]()
        
            while nodeArray.count > 0 {
            
                let left = nodeArray.removeFirst()
                let right = nodeArray.removeFirst()
                
                let combinedHash = left.hash.hexDescription + right.hash.hexDescription
                internalNodes.append(Merkletree(hash: (combinedHash).sha256, left: left, right: right))
            }
            nodeArray = internalNodes.count == 1 ? internalNodes : prepare(internalNodes) as! [Merkletree]
        }
        
        return nodeArray.first!
    }
    
    
    /// Appends copy of last hash if number of items is odd
    ///
    /// - Parameter hashes: <#hashes description#>
    /// - Returns: <#return value description#>
    private static func prepare(_ hashes: [Any]) -> [Any] {
        
        guard hashes.count > 0 else { return hashes }
        
        if hashes.count % 2 == 0 {
            
            return hashes
            
        } else {
            
            var evenHashes = hashes
            evenHashes.append(hashes.last!)
            
            return evenHashes
        }
    }
}

extension Merkletree: Sha256Hashable {
    
    public var sha256: Sha256Hash {
        return hash
    }

}

extension Merkletree: Equatable {
    
    public static func == (lhs: Merkletree, rhs: Merkletree) -> Bool {
        return lhs.hash == rhs.hash
    }
}
