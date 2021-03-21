//
//  KeyManagementRepositoryProtocol.swift
//  CredifyCore
//
//  Created by Nalou Nguyen on 15/03/2021.
//  Copyright © 2021 Credify One. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CredifyCryptoSwift

public protocol KeyManagementRepositoryProtocol: class {
    /**
     Generates a new encryption Key.
     - Parameters:
        - priKey: Private key restored from a pem file (PKCS#8)
        - pubKey: Public key restored from a pem file (PKCS#8)
        - password: Password in case the private key is encrypted
     */
    func generateEncryptionKeypair(priKey: String?, pubKey: String?, password: String?) -> Single<Encryption>
    func saveEncryptionKeyPair(_ keyPair: Encryption) -> Completable
    /**
     Generates a new signing Key.
     - Parameters:
        - priKey: Private key restored from a pem file (PKCS#8)
        - pubKey: Public key restored from a pem file (PKCS#8)
        - password: Password in case the private key is encrypted
     */
    func generateSigningKeyPair(priKey: String?, pubKey: String?, password: String?) -> Single<Signing>
    func saveSigningKeyPair(_ keyPair: Signing) -> Completable
    
    /// Return Encryption key pair
    func getEncryptionKey() -> Single<Encryption?>
    func getSigningKey() -> Single<Signing?>
    
    /// This fetches an encrypted private keys from Server.
    func fetchEncryptedKeys() -> Single<GetEncryptedKeysResponse>
    /// Returns a signature (e.g. for an auth header).
    func sign(_: String) throws -> String
    /// This operation signs verified PII with a user's signing private key. In this process, Credify backend will update the identity's `securing_status`.
    func signPII(identityId: String, identityHash: String) throws -> Observable<CommonResponse>
    
    func cacheAccessToken(_ token: String)
    
    func cachePassword(_ password: String) 

}


public class KeyManagementRepositoryManager: KeyManagementRepositoryProtocol {
    private let service: KeyManagementRepository = KeyManagementRepository()
    
    public func generateEncryptionKeypair(priKey: String?, pubKey: String?, password: String?) -> Single<Encryption> {
        return service.generateEncryptionKeypair(priKey: priKey, pubKey: pubKey, password: password)
    }
    
    public func saveEncryptionKeyPair(_ keyPair: Encryption) -> Completable {
        return service.saveEncryptionKeyPair(keyPair)
    }
    
    public func generateSigningKeyPair(priKey: String?, pubKey: String?, password: String?) -> Single<Signing> {
        return service.generateSigningKeyPair(priKey: priKey, pubKey: pubKey, password: password)
    }
    
    public func saveSigningKeyPair(_ keyPair: Signing) -> Completable {
        return service.saveSigningKeyPair(keyPair)
    }
    
    public func hasSession() -> Observable<Bool> {
        return service.hasSession()
    }
    
    public func hasAccessToken() -> Bool {
        return service.hasAccessToken()
    }
    
    public func getEncryptionKey() -> Single<Encryption?> {
        return service.getEncryptionKey()
    }
    
    public func getSigningKey() -> Single<Signing?> {
        return service.getSigningKey()
    }
    
    public func fetchEncryptedKeys() -> Single<GetEncryptedKeysResponse> {
        return service.fetchEncryptedKeys()
    }
    
    public func sign(_ message: String) throws -> String {
        return try service.sign(message)
    }
    
    public func signPII(identityId: String, identityHash: String) throws -> Observable<CommonResponse> {
        return service.signPII(identityId: identityId, identityHash: identityHash)
    }
    
    public func cacheAccessToken(_ token: String) {
        service.cacheAccessToken(token)
    }
    
    public func cachePassword(_ password: String) {
        service.cachePassword(password)
    }
}

