//
//  Transaction+validation.swift
//  ZKProofOfConcept
//
//  Created by Ronald "Danger" Mannak on 5/29/19.
//  Copyright © 2019 A Puzzle A Day. All rights reserved.
//

import Foundation

// Validation
extension Transaction {
    
    /**
     Creates a hash of the inputs and outputs of the inputs and outputs
     in the transaction. The hash is used for the signing the transaction.
     - parameter inputs:        Array of the inputs in the transaction.
     - parameter outputs:       Array of the outputs in the transaction.
     */
    public static func hash(inputs: [Entry], recipients: [Recipient]) -> Data {
        return [inputs.sha256, recipients.sha256].sha256
    }
    
    /**
     Validates that the signature was signed by sender and that the
     inputs and outputs are unaltered by comparing the signed hash with
     a computed hash value.
     - returns:     True if the signature is
     - throws:      Forwards error from Apple's encryption framework
     */
//    public func hasValidSignature() throws -> Bool {
//        let key = try Key(from: self.message.sender)
//        return try key.verify(signature: self.signature, digest: self.message.sha256)
//    }
    
    /**
     Checks if the transaction is a genesis transaction.
     - returns:     true if the transaction is a genesis transaction
     */
//    public var isGenesisTransaction: Bool {
//        return false
//        guard inputs.count == 0, outputs.count == 1 else { return false }
//        guard sender == Data(), signature == Data() else { return false }
//        return true
//    }
}

extension Transaction: CustomStringConvertible {
    public var description: String {
        return "\n\ntxId: ...\(id.hexDescription.suffix(4)), sender: ...\(message.sender.suffix(4))" //", \ninputs: \(self.inputs) \noutputs: \(self.recipients)"
    }
}

extension Transaction {
    
    public var isSignatureValid: Bool {
        
        guard id == message.sha256 else { return false }
        
        guard let address = self.message.inputs.first?.owner, let key = try? Key(from: address) else { return false }
        
        guard let _ = try? key.verify(signature: self.signature, digest: self.id) else { return false }
        
        return true
    }
}

extension Transaction {
    
    /// A payment is valid if:
    /// 1. The transaction was signed with the public key of the sender
    /// 2. All inputs are of a single and the correct type
    /// 3. The sender owns all the inputs
    /// 4. The sender has enough balance to pay the amount and fee
    /// 5. The balances are unlocked
    /// - The sender has enough balance to pay out the fee and the amount
    /// - The reciever has enough room for the amount s.t. there won't be an overflow
    /// - The account nonce matches the nonce inside the payment.
    ///
    /// - Throws: ZKError in case transaction is not valid
    private func validate(blockData: BlockData, result: (Bool, Error?) -> Void) {
        
        do {
            
            // Fetch input entries
            let inputs = self.message.inputs.filter({ $0.type == self.message.type })
            
            // 1. Are all types of inputs of the correct type?
            guard inputs.count == self.message.inputs.count else {
                throw ZKError.multipleEntryTypes
            }
            
            // Fetch output entries
            let outputs = self.message.outputs.filter({ $0.type == self.message.type })
            
            // 2. Are all types of outputs of the correct type?
            guard outputs.count == self.message.outputs.count else {
                throw ZKError.multipleEntryTypes
            }
            
            // 2. Is nonce equal to the nonce in the block provided?
//            guard inputs.count == self.message.nonces.count else {
//                throw ZKError.nonceError
//            }
//            for i in 0 ..< inputs.count {
//                guard inputs[i].nonce == self.message.nonces[i] else {
//                    throw ZKError.nonceError
//                }
//            }
            
            // Fetch public key
            let publicKey = try Key(from: self.message.sender)
            let publicKeyData = try publicKey.exportKey()
            
            // 1. Validates that the signature was signed by sender and that the
            // inputs and outputs are unaltered by comparing the signed hash with
            // a computed hash value.
            guard try publicKey.verify(signature: self.signature, digest: self.message.sha256) == true else {
                throw ZKError.verificationError
            }

            // 3. Are all inputs owned by sender?
            guard inputs.filter({ $0.owner == publicKeyData }).count == self.message.inputs.count else {
                throw ZKError.inputsNotOwnedBySender
            }
            
            // 4. Is balance sufficient?
            // TODO: check for overflow
            let availableBalance = self.message.inputs.reduce(0, { $0 + $1.balance })
            let spentAmount = self.message.recipients.reduce(0, { $0 + $1.amount })
            guard availableBalance >= spentAmount else {
                throw ZKError.insufficientBalance("Short \(spentAmount - availableBalance) tokens")
            }
            
            // TODO: 5. Are balances unlocked? Check predicates

        } catch {
            result(false, error)
        }
        
    }
}
