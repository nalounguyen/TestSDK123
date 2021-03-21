//
//  ClaimUseCaseManager.swift
//  CredifyCore
//
//  Created by Nalou Nguyen on 17/03/2021.
//  Copyright © 2021 Credify One. All rights reserved.
//

import Foundation
import RxSwift
import CredifyCryptoSwift

public class ClaimUseCaseManager: ClaimUseCaseProtocol {
    private let service: ClaimUseCase
    
    public init() {
        let repository = ClaimRepositoryManager()
        let kr = KeyManagementRepository()
        
        self.service = ClaimUseCase(repository: repository,
                                    kmRepository: kr)
    }
    
    public var errorEvent: Observable<CCError> {
        return service.errorEvent
    }
    
    public var getEncryptedClaimEvent: Observable<[CCScopeModel]> {
        return service.getEncryptedClaimEvent
    }
    
    public var getCustomScopeEvent: Observable<[CCScopeModel]> {
        return service.getCustomScopeEvent
    }
    
    // Used for SDK
    public func getEncryptedClaim() {
        service.getEncryptedClaim()
    }
    
    // Used for SDK
    public func getAttachedCustomClaims(providerId: String?) {
        service.getAttachedCustomClaims(providerId: providerId)
    }
}
