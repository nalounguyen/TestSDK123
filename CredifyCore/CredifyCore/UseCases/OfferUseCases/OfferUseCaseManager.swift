//
//  OfferUseCaseManager.swift
//  CredifyCore
//
//  Created by Nalou Nguyen on 16/03/2021.
//  Copyright © 2021 Credify One. All rights reserved.
//

import Foundation
import RxSwift

public class OfferUseCaseManager: OfferUseCaseProtocol {
    private let service: OfferUseCase
    
    public init() {
        let repository = OfferRepositoryManager()
        let kmRepository = KeyManagementRepository()
        
        self.service = OfferUseCase(repository: repository,
                                    kmRepository: kmRepository)
    }
    
    public var offerRedeemEvent: Observable<CCOfferRedeem> {
        return service.offerRedeemEvent
    }
    
    public var offerEvaluationEvent: Observable<Int> {
        return service.offerEvaluationEvent
    }
    
    public var requiredScopeEvent: Observable<[CCScopeData]> {
        return service.requiredScopeEvent
    }
    
    public var errorEvent: Observable<CCError> {
        return service.errorEvent
    }
    
    public func getOfferEvaluation(offerCode: String,
                            selectedScopes: [CCScopeModel]) {
        return service.getOfferEvaluation(offerCode: offerCode,
                                          selectedScopes: selectedScopes)
    }
    
    public func getOfferRedeem(entityId: String,
                        offerInfo: CCOfferData,
                        listScope: [CCScopeModel]) {
        return service.getOfferRedeem(entityId: entityId,
                                      offerInfo: offerInfo,
                                      listScope: listScope)
    }
    
    
}
