//
//  KeyManagementUseCasesProtocol.swift
//  CredifyCore
//
//  Created by Nalou Nguyen on 17/03/2021.
//  Copyright © 2021 Credify One. All rights reserved.
//

import Foundation
import RxSwift
import CredifyCryptoSwift


protocol KeyManagementUseCaseProtocol {
    var generateEncryptionKeyEvent: Observable<Encryption> { get }
    var generateSigningKeyEvent: Observable<Signing> { get }
    var errorEvent: Observable<CCError> { get }
    /**
     Generates a new encryption Key.
     - Parameters:
        - priKey: Private key restored from a pem file (PKCS#8)
        - pubKey: Public key restored from a pem file (PKCS#8)
        - password: Password in case the private key is encrypted
     */
    func generateEncryptionKeypair(priKey: String?, pubKey: String?, password: String?)
    
    /**
     Generates a new signing Key.
     - Parameters:
        - priKey: Private key restored from a pem file (PKCS#8)
        - pubKey: Public key restored from a pem file (PKCS#8)
        - password: Password in case the private key is encrypted
     */
    func generateSigningKeyPair(priKey: String?, pubKey: String?, password: String?)
    
}
