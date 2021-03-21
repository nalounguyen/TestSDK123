//
//  ProviderUseCaseManager.swift
//  CredifyCore
//
//  Created by Nalou Nguyen on 16/03/2021.
//  Copyright © 2021 Credify One. All rights reserved.
//

import Foundation

import Foundation
import RxSwift

public class ProviderUseCaseManager: ProviderUseCaseProtocol {
    private let service: ProviderUseCase
    public init() {
        let repository = ProviderRepositoryManager()
        let kmRepository = KeyManagementRepository()
        
        self.service = ProviderUseCase(repository: repository, kmRepository: kmRepository)
    }
    
    
    public var offersFromProviderEvent: Observable<[CCOfferData]> {
        return service.offersFromProviderEvent
    }
    
    public var credifyIdEvent: Observable<(credifyId: String, password: String)> {
        return service.credifyIdEvent
    }
    
    public var loginSuccessEvent: Observable<Void> {
        return service.loginSuccessEvent
    }
    
    public var errorEvent: Observable<CCError> {
        return service.errorEvent
    }
    
    public func getOffersFromProvider(phoneNumber: String?,
                                      countryCode: String?,
                                      localId: String,
                                      credifyId: String?) {
        
        service.getOffersFromProvider(phoneNumber: phoneNumber,
                                      countryCode: countryCode,
                                      localId: localId,
                                      credifyId: credifyId)
    }
    
    public func createsIndividualEntity(profile: CCProfileModel,
                                        password: String) {
        
        service.createsIndividualEntity(profile: profile,
                                        password: password)
    }
    
    public func loginWithPassword(mode: CCLoginMode, password: String) {
        service.loginWithPassword(mode: mode, password: password)
    }
    
    
    public func getCredifyIdFromProvider(userExternalInfo: CCUserExternalModel,
                                         password: String) {
        
        service.getCredifyIdFromProvider(userExternalInfo: userExternalInfo,
                                         password: password)
    }
    
    
}
