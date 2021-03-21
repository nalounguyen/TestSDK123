//
//  KeyManagementUseCases.swift
//  CredifyCore
//
//  Created by Nalou Nguyen on 17/03/2021.
//  Copyright © 2021 Credify One. All rights reserved.
//

import Foundation
import RxSwift
import CredifyCryptoSwift

// This is internal class.
class KeyManagementUseCase: KeyManagementUseCaseProtocol {
    private let repository: KeyManagementRepositoryProtocol
    private let bag = DisposeBag()
    
    private let generateEncryptionKeyEventSubject = PublishSubject<Encryption>()
    private let generateSigningKeyEventSubject = PublishSubject<Signing>()
    private let errorEventSubject = PublishSubject<CCError>()
    
    
    init(repository: KeyManagementRepositoryProtocol) {
        self.repository = repository

    }
    
    lazy var generateEncryptionKeyEvent: Observable<Encryption> = {
        return generateEncryptionKeyEventSubject.asObserver()
    }()
    
    lazy var generateSigningKeyEvent: Observable<Signing> = {
        return generateSigningKeyEventSubject.asObserver()
    }()
    
    lazy var errorEvent: Observable<CCError> = {
        return errorEventSubject.asObserver()
    }()
    
    
    func generateEncryptionKeypair(priKey: String?, pubKey: String?, password: String?) {
        
    }
    
    func generateSigningKeyPair(priKey: String?, pubKey: String?, password: String?) {
        
    }
    
//    func fetchEncryptedKeys() {
//        repository
//            .fetchEncryptedKeys()
//            .flatMap { (res) -> Single<(Encryption, Signing)> in
//                guard let password = CCSigner.password() else { return CCError.validationError(message: <#T##String#>)}
//                let generateEncryptionKeypair = self.kmRepository.generateEncryptionKeypair(priKey: res.data.encryptionSecret, pubKey: res.data.encryptionPublic, password: password)
//
//                let generateSigningKeyPair = self.kmRepository.generateSigningKeyPair(priKey: res.data.signingSecret, pubKey: res.data.signingPublic, password: password)
//        }
//    }
    
    
}
