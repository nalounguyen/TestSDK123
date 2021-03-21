//
//  KeyManagementUseCasesManager.swift
//  CredifyCore
//
//  Created by Nalou Nguyen on 17/03/2021.
//  Copyright © 2021 Credify One. All rights reserved.
//


import Foundation
import RxSwift
import CredifyCryptoSwift

public class KeyManagementUseCaseManager: KeyManagementUseCaseProtocol {
    private let service: KeyManagementUseCase
    
    public init() {
        let repository = KeyManagementRepository()
        
        self.service = KeyManagementUseCase(repository: repository)
    }
    
    
    
    lazy var generateEncryptionKeyEvent: Observable<Encryption> = {
        return service.generateEncryptionKeyEvent
    }()
    
    lazy var generateSigningKeyEvent: Observable<Signing> = {
        return service.generateSigningKeyEvent
    }()
    
    lazy var errorEvent: Observable<CCError> = {
        return service.errorEvent
    }()
    
    
    func generateEncryptionKeypair(priKey: String?,
                                   pubKey: String?,
                                   password: String?) {
        service.generateEncryptionKeypair(priKey: priKey,
                                          pubKey: pubKey,
                                          password: password)
    }
    
    func generateSigningKeyPair(priKey: String?,
                                pubKey: String?,
                                password: String?) {
        
        service.generateSigningKeyPair(priKey: priKey,
                                       pubKey: pubKey,
                                       password: password)
    }
    
    
}
