//
//  KeyManagementRepository.swift
//  Credify
//
//  Created by Nalou Nguyen on 05/03/2021.
//  Copyright © 2021 Credify. All rights reserved.
//

import Foundation

import RxSwift
import CredifyCryptoSwift
import RxCocoa

class KeyManagementRepository: KeyManagementRepositoryProtocol {
    func generateEncryptionKeypair(priKey: String?, pubKey: String?, password: String?) -> Single<Encryption> {
        return Single.create { single in
            var keypair: Encryption?
            var err: Error?
            let group = DispatchGroup()
            group.enter()
            
            DispatchQueue.global(qos: .default).async {
                do {
                    if priKey == nil && pubKey == nil {
                        keypair = try Encryption()
                    }else {
                        keypair = try Encryption(privateKey: priKey, publicKey: pubKey, password: password)
                    }
                    group.leave()
                } catch {
                    err = error
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                if let key = keypair {
                    single(.success(key))
                }else if let error = err {
                    single(.error(error))
                }else {
                    single(.error(CCError.unknown))
                }
            }
            return Disposables.create()
        }
    }
    
    func saveEncryptionKeyPair(_ keyPair: Encryption) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self = self else {
                completable(.error(CCError.storagePerformFailure))
                return Disposables.create()
            }
            do {
                try self.saveEncryptionKeys(keyPair)
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
    
    func generateSigningKeyPair(priKey: String?, pubKey: String?, password: String?) -> Single<Signing> {
        return Single.create { single in
            var keypair: Signing?
            var err: Error?
            let group = DispatchGroup()
            group.enter()
            
            DispatchQueue.global(qos: .default).async {
                do {
                    if priKey == nil && pubKey == nil {
                        keypair = try Signing()
                    }else {
                        keypair = try Signing(privateKey: priKey, publicKey: pubKey, password: password)
                    }
                    group.leave()
                } catch {
                    err = error
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                if let key = keypair {
                    single(.success(key))
                }else if let error = err {
                    single(.error(error))
                }else {
                    single(.error(CCError.unknown))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func saveSigningKeyPair(_ keyPair: Signing) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self = self else {
                completable(.error(CCError.storagePerformFailure))
                return Disposables.create()
            }
            
            do {
                try self.saveSigningKeys(keyPair)
                completable(.completed)
            } catch {
                completable(.error(error))
            }
            return Disposables.create()
        }
    }
    
    
    func getEncryptionKey() -> Single<Encryption?> {
        return Single.create { single in
            var encryptionKeyPair: Encryption?
            guard let keyPairData = CCKeychainAccessClient.getData(field: .encryptionKey) else {
                single(.success(nil))
                return Disposables.create()
            }
            guard let keyPair = try? JSONDecoder().decode(CCKeyPair.self, from: keyPairData) else {
                single(.success(nil))
                return Disposables.create()
            }
            
            let semaphore = DispatchSemaphore(value: 0)
            DispatchQueue.global(qos: .default).sync {
                do {
                    encryptionKeyPair = try Encryption(privateKey: keyPair.privKey, publicKey: keyPair.pubKey, password: nil)
                    semaphore.signal()
                } catch {
                    encryptionKeyPair = nil
                    semaphore.signal()
                }
            }
            semaphore.wait()
            single(.success(encryptionKeyPair))
            return Disposables.create()
        }
    }
    
    func getSigningKey() -> Single<Signing?> {
        return Single.create { single in
            var signingKeyPair: Signing?
            guard let keyPairData = CCKeychainAccessClient.getData(field: .signingKey) else {
                single(.success(nil))
                return Disposables.create()
            }
            guard let keyPair = try? JSONDecoder().decode(CCKeyPair.self, from: keyPairData) else {
                single(.success(nil))
                return Disposables.create()
            }
            
            let semaphore = DispatchSemaphore(value: 0)
            DispatchQueue.global(qos: .default).sync {
                do {
                    signingKeyPair = try Signing(privateKey: keyPair.privKey, publicKey: keyPair.pubKey, password: nil)
                    semaphore.signal()
                } catch {
                    signingKeyPair = nil
                    semaphore.signal()
                }
            }
            semaphore.wait()
            single(.success(signingKeyPair))
            return Disposables.create()
        }
    }
    
    func fetchEncryptedKeys() -> Single<GetEncryptedKeysResponse> {
        let req = GetEncryptedPrivateKeyRequest()
        return RestAPIClient.send(apiRequest: req).asSingle()
    }
    
    func hasSession() -> Observable<Bool> {
        return Observable.create { observer in
            guard
                let _ = CCKeychainAccessClient.get(field: .pincode),
                let _ = CCKeychainAccessClient.get(field: .signingKey)
            else {
                observer.onNext(false)
                observer.onCompleted()
                return Disposables.create()
            }
            observer.onNext(true)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func hasAccessToken() -> Bool {
        return CCSigner.accessToken() == nil ? false : true
    }
    
    func sign(_ message: String) throws -> String {
        do {
            guard let signingKeyPairData = CCKeychainAccessClient.getData(field: .signingKey) else {
                throw CCError.secretFailure
            }
            guard let signingKeyPair = try? JSONDecoder().decode(CCKeyPair.self, from: signingKeyPairData) else {
                throw CCError.secretFailure
            }
            
            let signing = try Signing(privateKey: signingKeyPair.privKey, publicKey: signingKeyPair.pubKey, password: nil)
            let signed = try signing.sign(message: message)
            return signed.base64EncodedString()
        } catch {
            throw error
        }
    }
    
    func signPII(identityId: String, identityHash: String) -> Observable<CommonResponse> {
        var signingKeyPair: Signing? = nil
        var signature = ""
        guard let keyPairData = CCKeychainAccessClient.getData(field: .signingKey),
              let keyPair = try? JSONDecoder().decode(CCKeyPair.self, from: keyPairData),
              !keyPair.privKey.isEmpty, !keyPair.pubKey.isEmpty else {
            
            return Observable<CommonResponse>.error(CCError.signFailure)
        }

        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global(qos: .default).sync {
            do {
                signingKeyPair = try Signing(privateKey: keyPair.privKey, publicKey: keyPair.pubKey, password: nil)
                semaphore.signal()
            } catch {
                semaphore.signal()
            }
        }
        semaphore.wait()
        if let data = try? signingKeyPair?.signBase64Url(message: identityHash, option: .base64URL) {
            signature = data
        }
        let req = SignatureForPII(signature: signature, identityId: identityId, identityHash: identityHash)
        return RestAPIClient.send(apiRequest: req)
    }
    
    func cacheAccessToken(_ token: String) {
        CCKeychainAccessClient.save(field: .accessToken, value: token)
    }
    
    func cachePassword(_ password: String) {
        CCKeychainAccessClient.save(field: .password, value: password)
    }
    
    
    // MARK: - Private methods
    
    private func savePublicKeys(_ keys: CCPublicKeys) throws {
        let encoded = try JSONEncoder().encode(keys)
        try CCKeychainAccessClient.save(field: .publicKeys, value: encoded)
    }
    
    private func saveEncryptionKeys(_ keyPair: Encryption) throws {
        let value = CCKeyPair(pubKey: keyPair.publicKeyPKCS8, privKey: keyPair.privateKeyPKCS8)
        let encoded = try JSONEncoder().encode(value)
        try CCKeychainAccessClient.save(field: .encryptionKey, value: encoded)
    }
    
    private func saveSigningKeys(_ keyPair: Signing) throws {
        let value = CCKeyPair(pubKey: keyPair.publicKeyPKCS8, privKey: keyPair.privateKeyPKCS8)
        let encoded = try JSONEncoder().encode(value)
        try CCKeychainAccessClient.save(field: .signingKey, value: encoded)
    }
}
