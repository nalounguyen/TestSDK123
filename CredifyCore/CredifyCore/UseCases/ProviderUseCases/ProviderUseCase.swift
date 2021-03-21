//
//  ProviderUseCase.swift
//  CredifyCore
//
//  Created by Nalou Nguyen on 15/03/2021.
//  Copyright © 2021 Credify One. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import CredifyCryptoSwift

class ProviderUseCase: ProviderUseCaseProtocol {
    private let repository: ProviderRepositoryProtocol
    private let kmRepository: KeyManagementRepositoryProtocol
    private let bag = DisposeBag()
    
    private let offersFromProviderEventSubject = PublishSubject<[CCOfferData]>()
    private let credifyIdEventSubject = PublishSubject<(credifyId: String, password: String)>()
    private let loginSuccessEventSubject = PublishSubject<Void>()
    private let errorEventSubject = PublishSubject<CCError>()
    
    init(repository: ProviderRepositoryProtocol,kmRepository: KeyManagementRepositoryProtocol) {
        self.repository = repository
        self.kmRepository = kmRepository
    }
    
    lazy var offersFromProviderEvent: Observable<[CCOfferData]> = {
        return offersFromProviderEventSubject.asObservable()
    }()
    
    lazy var credifyIdEvent: Observable<(credifyId: String, password: String)> = {
        return credifyIdEventSubject.asObservable()
    }()
    
    lazy var errorEvent: Observable<CCError> = {
        return errorEventSubject.asObserver()
    }()
    
    lazy var loginSuccessEvent: Observable<Void> = {
        return loginSuccessEventSubject.asObserver()
    }()
    
    
    func getOffersFromProvider(phoneNumber: String?, countryCode: String?, localId: String, credifyId: String?) {
        repository
            .getOffersFromProvider(phoneNumber:
                                    phoneNumber,
                                   countryCode: countryCode,
                                   localId: localId,
                                   credifyId: credifyId)
            .subscribe(onNext: { res in
                self.offersFromProviderEventSubject.onNext(res.data.offers)
            }, onError: { err in
                self.errorEventSubject.onNext(CCError(error: err))
            })
            .disposed(by: bag)
    }
    
    func createsIndividualEntity(profile: CCProfileModel,
                                 password: String) {
        let generateEncryption = kmRepository.generateEncryptionKeypair(priKey: nil, pubKey: nil, password: nil)
        let generateSigning = kmRepository.generateSigningKeyPair(priKey: nil, pubKey: nil, password: nil)
        
        
        Single
            .zip(generateEncryption, generateSigning)
            .asObservable().flatMap { (encryption, signing) -> Observable<CreatesIndividualEntityResponse> in
                return self.repository.createsIndividualEntity(profile: profile,
                                                               signingPublicKey: signing.publicKeyPKCS8,
                                                               signingSecret: signing.privateKeyPKCS8,
                                                               encryptionPublicKey: encryption.publicKeyPKCS8,
                                                               encryptionSecret: encryption.privateKeyPKCS8,
                                                               password: password)
            }
            .subscribe(onNext: { res in
                self.kmRepository.cachePassword(password)
                CoreService.shared.password = password
                self.credifyIdEventSubject.onNext((res.data.id, password))
            }, onError: { err in
                self.errorEventSubject.onNext(CCError(error: err))
            })
            .disposed(by: self.bag)
        
    }
    func loginWithPassword(mode: CCLoginMode,
                           password: String) {
        var encryptionKeyPair: Encryption?
        var signingKeyPair: Signing?
        _ = repository
            .retrieveAccessToken(mode: mode, password: password.sha256())
            .flatMap{ [weak self] res -> Single<GetEncryptedKeysResponse> in
                /// Cached `accessToken` and `password`
                guard let self = self else { return Single.error( CCError.unknown)}
                let accessToken = res.data.accessToken
                self.kmRepository.cacheAccessToken(accessToken)
                self.kmRepository.cachePassword(password)
                
                /// TODO: we also need backend to response `encryption PublicKey` and `signing PublicKey`
                return self.kmRepository.fetchEncryptedKeys()
            }
            .flatMap { (res) -> Single<(Encryption, Signing)> in
                /// Generate `EncryptionKey` and `SigningKey` with password
                let generateEncryptionKeypair = self.kmRepository.generateEncryptionKeypair(priKey: res.data.encryptionSecret, pubKey: res.data.encryptionPublic, password: password)
                
                let generateSigningKeyPair = self.kmRepository.generateSigningKeyPair(priKey: res.data.signingSecret, pubKey: res.data.signingPublic, password: password)
                
                return Single.zip(generateEncryptionKeypair, generateSigningKeyPair)
            }.flatMap { (encryptionKey, signingKey) -> Completable in
                /// Save `EncryptionKey` and `SigningKey` to keyChain
                let saveEncryptionKeyPair = self.kmRepository.saveEncryptionKeyPair(encryptionKey)
                let saveSigningKeyPair = self.kmRepository.saveSigningKeyPair(signingKey)
                
                encryptionKeyPair = encryptionKey
                signingKeyPair = signingKey
                return Completable
                    .zip(saveEncryptionKeyPair,
                         saveSigningKeyPair)
            }
            .subscribe(onError: { err in
                self.errorEventSubject.onNext(CCError(error: err))
            }, onCompleted: {
                CoreService.shared.encryption = encryptionKeyPair
                CoreService.shared.signing = signingKeyPair
                self.loginSuccessEventSubject.onNext(())
            }).disposed(by: bag)
    }
    
    func getCredifyIdFromProvider(userExternalInfo: CCUserExternalModel,
                                  password: String) {
        
        let generateEncryption = kmRepository.generateEncryptionKeypair(priKey: nil, pubKey: nil, password: nil)
        let generateSigning = kmRepository.generateSigningKeyPair(priKey: nil, pubKey: nil, password: nil)
        
        var signingKey: Signing?
        var encryptionKey: Encryption?
        
        Single
            .zip(generateEncryption, generateSigning)
            .asObservable()
            .flatMap { (encryption, signing) -> Observable<GetCredifyIdFromProviderResponse> in
                signingKey = signing
                encryptionKey = encryption
                let signingPri = try? signing.exportPrivateKey(password: password)
                let encryptionPri = try? encryption.exportPrivateKey(password: password)
                print("signing private key: \(signingPri)")
                print("encryption private key: \(encryptionPri)")
                return self.repository.getCredifyIdFromProvider(userExternalInfo: userExternalInfo,
                                                               signingPublicKey: signing.publicKeyPKCS8,
                                                               signingSecret: signingPri ?? "",
                                                               encryptionPublicKey: encryption.publicKeyPKCS8,
                                                               encryptionSecret: encryptionPri ?? "",
                                                               password: password)
                
            }
            .subscribe(onNext: { [weak self] res in
                guard let self = self else { return }
                self.kmRepository.cachePassword(password)
                self.credifyIdEventSubject.onNext((res.id, password))
                CoreService.shared.signing = signingKey
                CoreService.shared.encryption = encryptionKey
                
                
                
            }, onError: { [weak self] err in
                self?.errorEventSubject.onNext(CCError(error: err))
            })
            .disposed(by: self.bag)
    }
}

